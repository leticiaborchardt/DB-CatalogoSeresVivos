SET search_path TO SeresVivos;

-- TRIGGER: Atualiza a data de observação conforme última atualização no registro
CREATE OR REPLACE FUNCTION update_data_ultima_observacao()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE especie
    SET data_ultima_observacao = NEW.data_hora
    WHERE id = NEW.id_especie;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_update_data_ultima_observacao
AFTER INSERT ON historico_especie
FOR EACH ROW
EXECUTE FUNCTION update_data_ultima_observacao();

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