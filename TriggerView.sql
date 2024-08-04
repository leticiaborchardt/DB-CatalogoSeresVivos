SET search_path TO SeresVivos;

-- Função para atualizar data_ultima_observacao e inserir no historico_especie
CREATE OR REPLACE FUNCTION atualizar_especie_e_historico()
    RETURNS TRIGGER AS $$
BEGIN

    -- Desabilitar temporariamente o trigger
    PERFORM pg_catalog.set_config('session_replication_role', 'replica', true);

    -- Atualiza data_ultima_observacao na tabela especie
    UPDATE especie
    SET data_ultima_observacao = NEW.data_ultima_observacao
    WHERE id = NEW.id;

    -- Reabilitar o trigger
    PERFORM pg_catalog.set_config('session_replication_role', 'origin', true);

    -- Insere novo registro na tabela historico_especie
    INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora)
    VALUES (NEW.id, NEW.status_conservacao, NEW.populacao_total, NEW.data_ultima_observacao);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para chamar a função após atualização na tabela especie
CREATE OR REPLACE TRIGGER trg_atualizar_especie_e_historico
    AFTER UPDATE ON especie
    FOR EACH ROW
EXECUTE FUNCTION atualizar_especie_e_historico();

-- TRIGGER: atualiza o campo populacao_total na tabela especie conforme populacao_local adicionada nas localizações da espécie
CREATE OR REPLACE FUNCTION atualizar_populacao_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE especie
    SET populacao_total = (
        SELECT COALESCE(SUM(populacao_local), 0)
        FROM especie_localizacao
        WHERE id_especie = NEW.id_especie
    )
    WHERE id = NEW.id_especie;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_atualizar_populacao_total
AFTER INSERT OR UPDATE ON especie_localizacao
FOR EACH ROW
EXECUTE FUNCTION atualizar_populacao_total();

--trigger para atualizar status de conservação
CREATE OR REPLACE FUNCTION atualizar_status()
RETURNS TRIGGER AS $$
DECLARE
    novo_status VARCHAR;
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.populacao_total IS DISTINCT FROM NEW.populacao_total THEN
        novo_status := CASE
            WHEN NEW.populacao_total = 0 THEN 'Extinta'
            WHEN NEW.populacao_total BETWEEN 1 AND 50 THEN 'Criticamente em Perigo'
            WHEN NEW.populacao_total BETWEEN 51 AND 250 THEN 'Em Perigo'
            WHEN NEW.populacao_total BETWEEN 251 AND 1000 THEN 'Vulnerável'
            WHEN NEW.populacao_total BETWEEN 1001 AND 5000 THEN 'Quase Ameaçada'
            WHEN NEW.populacao_total > 5000 THEN 'Pouco Preocupante'
            ELSE NEW.status_conservacao
        END;
		UPDATE especie
		SET status_conservacao = novo_status
		WHERE id = NEW.id;
    END IF;

    IF TG_OP = 'INSERT' THEN
        novo_status := CASE
            WHEN NEW.populacao_total = 0 THEN 'Extinta'
            WHEN NEW.populacao_total BETWEEN 1 AND 50 THEN 'Criticamente em Perigo'
            WHEN NEW.populacao_total BETWEEN 51 AND 250 THEN 'Em Perigo'
            WHEN NEW.populacao_total BETWEEN 251 AND 1000 THEN 'Vulnerável'
            WHEN NEW.populacao_total BETWEEN 1001 AND 5000 THEN 'Quase Ameaçada'
            WHEN NEW.populacao_total > 5000 THEN 'Pouco Preocupante'
            ELSE NULL
        END;  
		UPDATE especie
		SET status_conservacao = novo_status
		WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_status
AFTER INSERT OR UPDATE ON especie
FOR EACH ROW
EXECUTE FUNCTION atualizar_status();

-- TRIGGER: Verifica inserções ou atualizações de espécies e emite um alerta caso o status de conservação esteja em perigo.
CREATE OR REPLACE FUNCTION verificar_status_conservacao() RETURNS trigger AS $$
BEGIN
    IF NEW.status_conservacao IN ('Vulnerável', 'Em Perigo', 'Criticamente em Perigo') THEN
        PERFORM pg_notify('alerta_conservacao', 'Espécie com conservação em estado ameaçado: ' || NEW.id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_verificar_status_conservacao
AFTER INSERT OR UPDATE ON especie
FOR EACH ROW
EXECUTE FUNCTION verificar_status_conservacao();

-- Adicionar código abaixo, antes dos inserts, para o funcionamento dos alertas:
LISTEN alerta_conservacao;

-- VIEW: Riqueza de espécies por localização
CREATE OR REPLACE VIEW view_especies_por_localizacao AS
SELECT 
    l.id AS id_localizacao,
	l.regiao AS regiao_geografica,
    l.nome AS nome_localizacao,
    p.nome AS nome_pais,
    COUNT(DISTINCT el.id_especie) AS riqueza_especies
FROM localizacao l
INNER JOIN especie_localizacao el ON l.id = el.id_localizacao
INNER JOIN pais p ON l.id_pais = p.id
GROUP BY l.id, l.nome, p.nome
ORDER BY l.id;

-- VIEW: Distribuição geográfica de espécies ameaçadas
CREATE OR REPLACE VIEW view_regiao_geografica_especies_ameacadas AS
SELECT 
    e.nome_cientifico, 
    e.nome_comum, 
    e.status_conservacao, 
    l.nome AS localizacao, 
    l.regiao
FROM 
    especie e
INNER JOIN 
    especie_localizacao el ON e.id = el.id_especie
INNER JOIN 
    localizacao l ON el.id_localizacao = l.id
WHERE 
    e.status_conservacao IN ('Vulnerável', 'Em Perigo', 'Criticamente em Perigo');   

--VIEW: espécies endêmicas de um país
CREATE OR REPLACE VIEW view_especies_endemicas_pais AS
SELECT 
    e.nome_comum AS especie,
	pa.nome AS pais
FROM pais pa
INNER JOIN localizacao l ON l.id_pais = pa.id
INNER JOIN especie_localizacao el ON el.id_localizacao = l.id
INNER JOIN especie e ON e.id = el.id_especie
WHERE
	NOT EXISTS (
		SELECT 1
		FROM especie_localizacao el2
		INNER JOIN localizacao l2 ON l2.id = el2.id_localizacao
		INNER JOIN pais pa2 ON pa2.id = l2.id_pais
		WHERE el2.id_especie = e.id
		AND l2.id_pais != pa.id
)
GROUP BY pa.nome, e.nome_comum
ORDER BY pa.nome;