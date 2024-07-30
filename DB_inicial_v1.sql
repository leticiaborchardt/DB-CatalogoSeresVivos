-- Tabela Reino
CREATE TABLE Reino (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- Tabela Filo
CREATE TABLE Filo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    reino_id INTEGER REFERENCES Reino(id)
);

-- Tabela Classe
CREATE TABLE Classe (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    filo_id INTEGER REFERENCES Filo(id)
);

-- Tabela Ordem
CREATE TABLE Ordem (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    classe_id INTEGER REFERENCES Classe(id)
);

-- Tabela Família
CREATE TABLE Familia (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ordem_id INTEGER REFERENCES Ordem(id)
);

-- Tabela Gênero
CREATE TABLE Genero (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    familia_id INTEGER REFERENCES Familia(id)
);

-- Tabela Espécie
CREATE TABLE Especie (
    id SERIAL PRIMARY KEY,
    nome_cientifico VARCHAR(150) NOT NULL,
    nome_comum VARCHAR(150),
    descricao TEXT,
    id_genero INTEGER REFERENCES Genero(id),
    status_conservacao VARCHAR(50),
    ultima_observacao TIMESTAMP,
    populacao_total INTEGER
);

-- Tabela Localizacao
CREATE TABLE Localizacao (
    id SERIAL PRIMARY KEY,
    regiao GEOMETRY NOT NULL,
    nome VARCHAR(150) NOT NULL
);

-- Tabela Area_Protegida
CREATE TABLE Area_Protegida (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    id_localizacao INTEGER REFERENCES Localizacao(id)
);

-- Tabela Especie_Area_Protegida
CREATE TABLE Especie_Area_Protegida (
	id SERIAL PRIMARY KEY,
    id_especie INTEGER REFERENCES Especie(id),
    id_area_protegida INTEGER REFERENCES Area_Protegida(id)
);

-- Tabela Especie_Localizacao
CREATE TABLE Especie_Localizacao (
	id SERIAL PRIMARY KEY,
    id_especie INTEGER REFERENCES Especie(id),
    id_localizacao INTEGER REFERENCES Localizacao(id),
    populacao_local INTEGER
);

-- Tabela Doenca
CREATE TABLE Doenca (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela Especie_Doenca
CREATE TABLE Especie_Doenca (
	id SERIAL PRIMARY KEY,
    id_especie INTEGER REFERENCES Especie(id),
    id_doenca INTEGER REFERENCES Doenca(id),
    taxa_mortalidade FLOAT
);

-- Tabela Interacao_Ecologica
CREATE TABLE Interacao_Ecologica (
    id SERIAL PRIMARY KEY,
    id_especie1 INTEGER REFERENCES Especie(id),
    id_especie2 INTEGER REFERENCES Especie(id),
    tipo VARCHAR(100),
    descricao TEXT
);