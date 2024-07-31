-- Tabela Reino
CREATE TABLE reino (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- Tabela Filo
CREATE TABLE filo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    reino_id INTEGER NOT NULL REFERENCES reino(id)
);

-- Tabela Classe
CREATE TABLE classe (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    filo_id INTEGER NOT NULL REFERENCES filo(id)
);

-- Tabela Ordem
CREATE TABLE ordem (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    classe_id INTEGER NOT NULL REFERENCES classe(id)
);

-- Tabela Família
CREATE TABLE familia (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ordem_id INTEGER NOT NULL REFERENCES ordem(id)
);

-- Tabela Gênero
CREATE TABLE genero (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    familia_id INTEGER NOT NULL REFERENCES familia(id)
);

-- Tabela Espécie
CREATE TABLE especie (
    id SERIAL PRIMARY KEY,
    nome_cientifico VARCHAR(150) NOT NULL,
    nome_comum VARCHAR(150) NOT NULL,
    descricao TEXT,
    id_genero INTEGER NOT NULL REFERENCES genero(id),
    status_conservacao VARCHAR(50),
    data_ultima_observacao TIMESTAMP NOT NULL,
    populacao_total INTEGER NOT NULL CHECK (populacao_total >= 0)
);

-- Tabela País
CREATE TABLE pais(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE
);

-- Tabela Bioma
CREATE TABLE bioma(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE
);

-- Tabela Localização
CREATE TABLE localizacao (
    id SERIAL PRIMARY KEY,
    regiao GEOGRAPHY NOT NULL,
    nome VARCHAR(150) NOT NULL,
    id_pais INTEGER NOT NULL REFERENCES pais(id),
    area_protegida BOOLEAN NOT NULL
);

-- Tabela Localização-Bioma
CREATE TABLE localizacao_bioma (
    id SERIAL PRIMARY KEY,
    id_localizacao INTEGER NOT NULL REFERENCES localizacao(id),
    id_bioma INTEGER NOT NULL REFERENCES bioma(id),
    UNIQUE (id_localizacao, id_bioma)
);

-- Tabela Espécie-Localização
CREATE TABLE especie_localizacao (
    id SERIAL PRIMARY KEY,
    id_especie INTEGER NOT NULL REFERENCES especie(id),
    id_localizacao INTEGER NOT NULL REFERENCES localizacao(id),
    populacao_local INTEGER NOT NULL CHECK (populacao_local >= 0),
    UNIQUE (id_especie, id_localizacao)
);

-- Tabela Doença
CREATE TABLE doenca (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

-- Tabela Espécie-Doença
CREATE TABLE especie_doenca (
    id SERIAL PRIMARY KEY,
    id_especie INTEGER NOT NULL REFERENCES especie(id),
    id_doenca INTEGER NOT NULL REFERENCES doenca(id),
    taxa_mortalidade FLOAT NOT NULL CHECK (taxa_mortalidade >= 0 AND taxa_mortalidade <= 1),
    UNIQUE (id_especie, id_doenca)
);

-- Tabela de Interação Ecológica
CREATE TABLE interacao_ecologica (
    id SERIAL PRIMARY KEY,
    id_especie1 INTEGER NOT NULL REFERENCES especie(id),
    id_especie2 INTEGER NOT NULL REFERENCES especie(id),
    tipo VARCHAR(100),
    descricao TEXT,
    CHECK (id_especie1 <> id_especie2),
    UNIQUE (id_especie1, id_especie2, tipo)
);

-- Tabela Historico-Espécie
CREATE TABLE historico_especie (
    id SERIAL PRIMARY KEY,
    id_especie INTEGER NOT NULL REFERENCES especie(id),
    ultimo_status VARCHAR(50) NOT NULL,
    ultima_populacao INTEGER NOT NULL CHECK (ultima_populacao >= 0),
    data_hora TIMESTAMP NOT NULL
);
