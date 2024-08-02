SET search_path TO SeresVivos;

-- Atualizar data observação conforme última atualização no registro

-- Cria a função do trigger
CREATE OR REPLACE FUNCTION update_data_ultima_observacao()
RETURNS TRIGGER AS $$
BEGIN
	-- Atualiza a data_ultima_observação na tabela especie
    UPDATE especie
    SET data_ultima_observacao = NEW.data_hora
    WHERE id = NEW.id_especie;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Cria o trigger
CREATE TRIGGER trg_update_data_ultima_observacao
AFTER INSERT ON historico_especie
FOR EACH ROW
EXECUTE FUNCTION update_data_ultima_observacao();

-- Trigger responsável por atualizar o campo populacao_total na tabela especie conforme populacao_local adicionada nas localizações da espécie.
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

CREATE TRIGGER trg_atualizar_populacao_total
AFTER INSERT OR UPDATE ON especie_localizacao
FOR EACH ROW
EXECUTE FUNCTION atualizar_populacao_total();

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