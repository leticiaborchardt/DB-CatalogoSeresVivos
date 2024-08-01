CREATE SCHEMA SeresVivos;

SET search_path TO SeresVivos;

CREATE EXTENSION postgis;

SELECT PostGIS_Version();

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
    populacao_total BIGINT NOT NULL CHECK (populacao_total >= 0)
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
    ultima_populacao BIGINT NOT NULL CHECK (ultima_populacao >= 0),
    data_hora TIMESTAMP NOT NULL
);

-- Inserts para a tabela Reino
INSERT INTO reino (nome) VALUES ('Animalia');
INSERT INTO reino (nome) VALUES ('Plantae');
INSERT INTO reino (nome) VALUES ('Fungi');
INSERT INTO reino (nome) VALUES ('Protista');
INSERT INTO reino (nome) VALUES ('Archaea');
INSERT INTO reino (nome) VALUES ('Bacteria');
INSERT INTO reino (nome) VALUES ('Chromista');
INSERT INTO reino (nome) VALUES ('Viruses');
INSERT INTO reino (nome) VALUES ('Viroids');
INSERT INTO reino (nome) VALUES ('Prions');

-- Inserts para a tabela Filo
INSERT INTO filo (nome, reino_id) VALUES ('Chordata', 1);
INSERT INTO filo (nome, reino_id) VALUES ('Arthropoda', 1);
INSERT INTO filo (nome, reino_id) VALUES ('Mollusca', 1);
INSERT INTO filo (nome, reino_id) VALUES ('Bryophyta', 2);
INSERT INTO filo (nome, reino_id) VALUES ('Pteridophyta', 2);
INSERT INTO filo (nome, reino_id) VALUES ('Ascomycota', 3);
INSERT INTO filo (nome, reino_id) VALUES ('Basidiomycota', 3);
INSERT INTO filo (nome, reino_id) VALUES ('Ciliophora', 4);
INSERT INTO filo (nome, reino_id) VALUES ('Euglenozoa', 4);

-- Inserts para a tabela Classe
INSERT INTO classe (nome, filo_id) VALUES ('Mammalia', 1);
INSERT INTO classe (nome, filo_id) VALUES ('Aves', 1);
INSERT INTO classe (nome, filo_id) VALUES ('Insecta', 2);
INSERT INTO classe (nome, filo_id) VALUES ('Gastropoda', 3);
INSERT INTO classe (nome, filo_id) VALUES ('Bryopsida', 4);
INSERT INTO classe (nome, filo_id) VALUES ('Polypodiopsida', 5);
INSERT INTO classe (nome, filo_id) VALUES ('Saccharomycetes', 6);
INSERT INTO classe (nome, filo_id) VALUES ('Agaricomycetes', 7);
INSERT INTO classe (nome, filo_id) VALUES ('Oligohymenophorea', 8);
INSERT INTO classe (nome, filo_id) VALUES ('Kinetoplastea', 9);

-- Inserts para a tabela Ordem
INSERT INTO ordem (nome, classe_id) VALUES ('Primates', 1);
INSERT INTO ordem (nome, classe_id) VALUES ('Carnivora', 1);
INSERT INTO ordem (nome, classe_id) VALUES ('Passeriformes', 2);
INSERT INTO ordem (nome, classe_id) VALUES ('Coleoptera', 3);
INSERT INTO ordem (nome, classe_id) VALUES ('Stylommatophora', 4);
INSERT INTO ordem (nome, classe_id) VALUES ('Bryales', 5);
INSERT INTO ordem (nome, classe_id) VALUES ('Polypodiales', 6);
INSERT INTO ordem (nome, classe_id) VALUES ('Saccharomycetales', 7);
INSERT INTO ordem (nome, classe_id) VALUES ('Agaricales', 8);
INSERT INTO ordem (nome, classe_id) VALUES ('Hymenostomatida', 9);

-- Inserts para a tabela Família
INSERT INTO familia (nome, ordem_id) VALUES ('Hominidae', 1);
INSERT INTO familia (nome, ordem_id) VALUES ('Felidae', 2);
INSERT INTO familia (nome, ordem_id) VALUES ('Turdidae', 3);
INSERT INTO familia (nome, ordem_id) VALUES ('Carabidae', 4);
INSERT INTO familia (nome, ordem_id) VALUES ('Helicidae', 5);
INSERT INTO familia (nome, ordem_id) VALUES ('Bryaceae', 6);
INSERT INTO familia (nome, ordem_id) VALUES ('Polypodiaceae', 7);
INSERT INTO familia (nome, ordem_id) VALUES ('Saccharomycetaceae', 8);
INSERT INTO familia (nome, ordem_id) VALUES ('Agaricaceae', 9);
INSERT INTO familia (nome, ordem_id) VALUES ('Parameciidae', 10);

-- Inserts para a tabela Gênero
INSERT INTO genero (nome, familia_id) VALUES ('Homo', 1);
INSERT INTO genero (nome, familia_id) VALUES ('Panthera', 2);
INSERT INTO genero (nome, familia_id) VALUES ('Turdus', 3);
INSERT INTO genero (nome, familia_id) VALUES ('Carabus', 4);
INSERT INTO genero (nome, familia_id) VALUES ('Helix', 5);
INSERT INTO genero (nome, familia_id) VALUES ('Bryum', 6);
INSERT INTO genero (nome, familia_id) VALUES ('Polypodium', 7);
INSERT INTO genero (nome, familia_id) VALUES ('Saccharomyces', 8);
INSERT INTO genero (nome, familia_id) VALUES ('Agaricus', 9);
INSERT INTO genero (nome, familia_id) VALUES ('Paramecium', 10);

-- Inserts para a tabela Espécie
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Homo sapiens', 'Humano', 'Espécie humana', 1, 'Pouco preocupante', '2023-10-01 00:00:00', 7800000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Panthera leo', 'Leão', 'Grande felino', 2, 'Vulnerável', '2023-10-01 00:00:00', 20000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Turdus merula', 'Melro', 'Pássaro comum', 3, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Carabus auratus', 'Carabídeo dourado', 'Besouro da família Carabidae', 4, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Helix pomatia', 'Caracol', 'Molusco gastrópode', 5, 'Pouco preocupante', '2023-10-01 00:00:00', 500000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Bryum argenteum', 'Musgo prateado', 'Musgo comum', 6, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Polypodium vulgare', 'Polipódio', 'Feto comum', 7, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Saccharomyces cerevisiae', 'Levedura de cerveja', 'Fungo utilizado na fermentação', 8, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Agaricus bisporus', 'Cogumelo de Paris', 'Cogumelo comestível', 9, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Paramecium caudatum', 'Paramécio', 'Protozoário ciliado', 10, 'Pouco preocupante', '2023-10-01 00:00:00', 1000000);

-- Inserts para a tabela País
INSERT INTO pais (nome) VALUES ('Brasil');
INSERT INTO pais (nome) VALUES ('Estados Unidos');
INSERT INTO pais (nome) VALUES ('França');
INSERT INTO pais (nome) VALUES ('Alemanha');
INSERT INTO pais (nome) VALUES ('Austrália');
INSERT INTO pais (nome) VALUES ('Argentina');
INSERT INTO pais (nome) VALUES ('Canadá');
INSERT INTO pais (nome) VALUES ('China');
INSERT INTO pais (nome) VALUES ('Índia');
INSERT INTO pais (nome) VALUES ('Japão');

-- Inserts para a tabela Bioma
INSERT INTO bioma (nome) VALUES ('Amazônia');
INSERT INTO bioma (nome) VALUES ('Cerrado');
INSERT INTO bioma (nome) VALUES ('Mata Atlântica');
INSERT INTO bioma (nome) VALUES ('Pantanal');
INSERT INTO bioma (nome) VALUES ('Pampa');
INSERT INTO bioma (nome) VALUES ('Caatinga');
INSERT INTO bioma (nome) VALUES ('Floresta Temperada');
INSERT INTO bioma (nome) VALUES ('Deserto');
INSERT INTO bioma (nome) VALUES ('Tundra');
INSERT INTO bioma (nome) VALUES ('Savanas Africanas');

-- Inserts para a tabela Localização
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(-43.2096 -22.9035)'), 'Parque Nacional da Tijuca', 1, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(-58.3816 -34.6037)'), 'Reserva Ecológica Costanera Sur', 6, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(13.4050 52.5200)'), 'Tiergarten', 4, FALSE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(151.2093 -33.8688)'), 'Royal Botanic Garden', 5, FALSE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(-0.1276 51.5074)'), 'Hyde Park', 2, FALSE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(2.3522 48.8566)'), 'Parque Nacional de Fontainebleau', 3, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(116.4074 39.9042)'), 'Parque Florestal de Pequim', 8, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(77.1025 28.7041)'), 'Parque Nacional de Delhi', 9, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(139.6917 35.6895)'), 'Parque Nacional de Shinjuku Gyoen', 10, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(-79.3832 43.6532)'), 'Parque Nacional de Toronto', 7, TRUE);

-- Inserts para a tabela Localização-Bioma
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (1, 1);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (2, 2);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (3, 3);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (4, 4);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (5, 5);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (6, 6);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (7, 7);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (8, 8);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (9, 9);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (10, 10);

-- Inserts para a tabela Espécie-Localização
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (1, 1, 100);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (2, 2, 200);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (3, 3, 300);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (4, 4, 400);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (5, 5, 500);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (6, 6, 600);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (7, 7, 700);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (8, 8, 800);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (9, 9, 900);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (10, 10, 1000);

-- Inserts para a tabela Doença
INSERT INTO doenca (nome, descricao) VALUES ('Gripe', 'Doença viral comum que afeta o sistema respiratório');
INSERT INTO doenca (nome, descricao) VALUES ('COVID-19', 'Doença causada pelo coronavírus SARS-CoV-2');
INSERT INTO doenca (nome, descricao) VALUES ('Tuberculose', 'Doença infecciosa causada pela bactéria Mycobacterium tuberculosis');
INSERT INTO doenca (nome, descricao) VALUES ('HIV/AIDS', 'Doença causada pelo vírus da imunodeficiência humana');
INSERT INTO doenca (nome, descricao) VALUES ('Ebola', 'Doença viral grave causada pelo vírus Ebola');
INSERT INTO doenca (nome, descricao) VALUES ('Raiva', 'Doença viral que afeta o sistema nervoso central');
INSERT INTO doenca (nome, descricao) VALUES ('Parvovirose', 'Doença viral que afeta cães');
INSERT INTO doenca (nome, descricao) VALUES ('Antraz', 'Doença bacteriana que afeta mamíferos');
INSERT INTO doenca (nome, descricao) VALUES ('Peste Suína Africana', 'Doença viral que afeta suínos');
INSERT INTO doenca (nome, descricao) VALUES ('Doença de Newcastle', 'Doença viral que afeta aves');
INSERT INTO doenca (nome, descricao) VALUES ('Febre Aftosa', 'Doença viral que afeta bovinos');
INSERT INTO doenca (nome, descricao) VALUES ('Leishmaniose', 'Doença parasitária que afeta mamíferos');
INSERT INTO doenca (nome, descricao) VALUES ('Malária', 'Doença parasitária que afeta humanos e outros primatas');
INSERT INTO doenca (nome, descricao) VALUES ('Brucelose', 'Doença bacteriana que afeta bovinos e suínos');
INSERT INTO doenca (nome, descricao) VALUES ('Toxoplasmose', 'Doença parasitária que afeta mamíferos e aves');

-- Inserts para a tabela Espécie-Doença
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (1, 1, 0.01);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (2, 2, 0.02);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (3, 3, 0.03);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (4, 4, 0.04);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (5, 5, 0.05);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (6, 6, 0.10);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (7, 7, 0.20);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (8, 8, 0.30);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (9, 9, 0.40);
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (10, 10, 0.50);

-- Inserts para a tabela de Interação Ecológica
INSERT INTO interacao_ecologica (id_especie1, id_especie2, tipo, descricao) VALUES (1, 2, 'Competição', 'Competição por recursos entre espécies 1 e 2');
INSERT INTO interacao_ecologica (id_especie1, id_especie2, tipo, descricao) VALUES (3, 4, 'Predação', 'Espécie 3 preda a espécie 4');
INSERT INTO interacao_ecologica (id_especie1, id_especie2, tipo, descricao) VALUES (5, 6, 'Mutualismo', 'Espécie 5 e espécie 6 têm uma relação mutualística');
INSERT INTO interacao_ecologica (id_especie1, id_especie2, tipo, descricao) VALUES (7, 8, 'Comensalismo', 'Espécie 7 se beneficia da espécie 8 sem prejudicá-la');
INSERT INTO interacao_ecologica (id_especie1, id_especie2, tipo, descricao) VALUES (9, 10, 'Parasitismo', 'Espécie 9 é parasita da espécie 10');

-- Inserts para a tabela Historico-Espécie
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (1, 'Pouco preocupante', 7800000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (2, 'Vulnerável', 20000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (3, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (4, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (5, 'Pouco preocupante', 500000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (6, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (7, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (8, 'Pouco preocupante', 1000000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (9, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');
INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora) VALUES (10, 'Pouco preocupante', 1000000, '2023-10-01 00:00:00');

INSERT INTO historico_especie (id_especie, ultimo_status, ultima_populacao, data_hora)
VALUES (1, 'Endangered', 1500, '2023-10-01 12:00:00');
