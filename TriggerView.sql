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