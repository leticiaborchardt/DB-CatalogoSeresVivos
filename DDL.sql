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
    id_reino INTEGER NOT NULL REFERENCES reino(id)
);

-- Tabela Classe
CREATE TABLE classe (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    id_filo INTEGER NOT NULL REFERENCES filo(id)
);

-- Tabela Ordem
CREATE TABLE ordem (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    id_classe INTEGER NOT NULL REFERENCES classe(id)
);

-- Tabela Família
CREATE TABLE familia (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    id_ordem INTEGER NOT NULL REFERENCES ordem(id)
);

-- Tabela Gênero
CREATE TABLE genero (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    id_familia INTEGER NOT NULL REFERENCES familia(id)
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
INSERT INTO filo (nome, id_reino) VALUES ('Chordata', 1);
INSERT INTO filo (nome, id_reino) VALUES ('Arthropoda', 1);
INSERT INTO filo (nome, id_reino) VALUES ('Mollusca', 1);
INSERT INTO filo (nome, id_reino) VALUES ('Bryophyta', 2);
INSERT INTO filo (nome, id_reino) VALUES ('Pteridophyta', 2);
INSERT INTO filo (nome, id_reino) VALUES ('Ascomycota', 3);
INSERT INTO filo (nome, id_reino) VALUES ('Basidiomycota', 3);
INSERT INTO filo (nome, id_reino) VALUES ('Ciliophora', 4);
INSERT INTO filo (nome, id_reino) VALUES ('Euglenozoa', 4);

-- Inserts para a tabela Classe
INSERT INTO classe (nome, id_filo) VALUES ('Mammalia', 1);
INSERT INTO classe (nome, id_filo) VALUES ('Aves', 1);
INSERT INTO classe (nome, id_filo) VALUES ('Insecta', 2);
INSERT INTO classe (nome, id_filo) VALUES ('Gastropoda', 3);
INSERT INTO classe (nome, id_filo) VALUES ('Bryopsida', 4);
INSERT INTO classe (nome, id_filo) VALUES ('Polypodiopsida', 5);
INSERT INTO classe (nome, id_filo) VALUES ('Saccharomycetes', 6);
INSERT INTO classe (nome, id_filo) VALUES ('Agaricomycetes', 7);
INSERT INTO classe (nome, id_filo) VALUES ('Oligohymenophorea', 8);
INSERT INTO classe (nome, id_filo) VALUES ('Kinetoplastea', 9);
INSERT INTO classe (nome, id_filo) VALUES ('Reptilia', 1);

-- Inserts para a tabela Ordem
INSERT INTO ordem (nome, id_classe) VALUES ('Primates', 1);
INSERT INTO ordem (nome, id_classe) VALUES ('Carnivora', 1);
INSERT INTO ordem (nome, id_classe) VALUES ('Passeriformes', 2);
INSERT INTO ordem (nome, id_classe) VALUES ('Coleoptera', 3);
INSERT INTO ordem (nome, id_classe) VALUES ('Stylommatophora', 4);
INSERT INTO ordem (nome, id_classe) VALUES ('Bryales', 5);
INSERT INTO ordem (nome, id_classe) VALUES ('Polypodiales', 6);
INSERT INTO ordem (nome, id_classe) VALUES ('Saccharomycetales', 7);
INSERT INTO ordem (nome, id_classe) VALUES ('Agaricales', 8);
INSERT INTO ordem (nome, id_classe) VALUES ('Hymenostomatida', 9);
INSERT INTO ordem (nome, id_classe) VALUES ('Squamata', 11);

-- Inserts para a tabela Família
INSERT INTO familia (nome, id_ordem) VALUES ('Hominidae', 1);
INSERT INTO familia (nome, id_ordem) VALUES ('Felidae', 2);
INSERT INTO familia (nome, id_ordem) VALUES ('Turdidae', 3);
INSERT INTO familia (nome, id_ordem) VALUES ('Carabidae', 4);
INSERT INTO familia (nome, id_ordem) VALUES ('Helicidae', 5);
INSERT INTO familia (nome, id_ordem) VALUES ('Bryaceae', 6);
INSERT INTO familia (nome, id_ordem) VALUES ('Polypodiaceae', 7);
INSERT INTO familia (nome, id_ordem) VALUES ('Saccharomycetaceae', 8);
INSERT INTO familia (nome, id_ordem) VALUES ('Agaricaceae', 9);
INSERT INTO familia (nome, id_ordem) VALUES ('Parameciidae', 10);
INSERT INTO familia (nome, id_ordem) VALUES ('Viperidae', 11);
INSERT INTO familia (nome, ordem_id) VALUES ('Tyrannidae', 3);

-- Inserts para a tabela Gênero
INSERT INTO genero (nome, id_familia) VALUES ('Homo', 1);
INSERT INTO genero (nome, id_familia) VALUES ('Panthera', 2);
INSERT INTO genero (nome, id_familia) VALUES ('Turdus', 3);
INSERT INTO genero (nome, id_familia) VALUES ('Carabus', 4);
INSERT INTO genero (nome, id_familia) VALUES ('Helix', 5);
INSERT INTO genero (nome, id_familia) VALUES ('Bryum', 6);
INSERT INTO genero (nome, id_familia) VALUES ('Polypodium', 7);
INSERT INTO genero (nome, id_familia) VALUES ('Saccharomyces', 8);
INSERT INTO genero (nome, id_familia) VALUES ('Agaricus', 9);
INSERT INTO genero (nome, id_familia) VALUES ('Paramecium', 10);
INSERT INTO genero (nome, id_familia) VALUES ('Bothrops', 11);
INSERT INTO genero (nome, familia_id) VALUES ('Tyrannus', 12);
INSERT INTO genero (nome, familia_id) VALUES ('Elaenia', 12);

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
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Bothrops erythromelas', 'Jaracuçu', 'Uma serpente venenosa encontrada na Caatinga.', 11, 'Vulnerável', '2024-08-01 00:00:00', 150);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Tyrannus savana', 'Tirano-dos-campos', 'Uma ave comum em áreas abertas.', 12, 'Pouco Preocupante', '2024-08-01 00:00:00', 500);
INSERT INTO especie (nome_cientifico, nome_comum, descricao, id_genero, status_conservacao, data_ultima_observacao, populacao_total)
VALUES ('Elaenia cristata', 'Maria-cavaleira', 'Uma ave encontrada em áreas montanhosas.', 13, 'Pouco Preocupante', '2024-08-01 00:00:00', 300);

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
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(39.2 -6.2)'), 'Parque Nacional da Caatinga', 1, TRUE),
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINT(40.5 -7.5)'), 'Área de Caatinga', 1, FALSE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINTZ(-72.6 42.4 2500)'), 'Montanhas Altas', 1, TRUE);
INSERT INTO localizacao (regiao, nome, id_pais, area_protegida) VALUES (ST_GeogFromText('SRID=4326;POINTZ(-73.1 42.7 800)'), 'Colinas Baixas', 1, FALSE);

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
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (11, 6);
INSERT INTO localizacao_bioma (id_localizacao, id_bioma) VALUES (12, 6);

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
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (11, 11, 50);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (11, 12, 100);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (12, 14, 200);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (13, 13, 150);
INSERT INTO especie_localizacao (id_especie, id_localizacao, populacao_local) VALUES (13, 14, 100);

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
INSERT INTO doenca (nome, descricao) VALUES ('Doença da Boca', 'Doença infecciosa que afeta a boca das serpentes.');

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
INSERT INTO especie_doenca (id_especie, id_doenca, taxa_mortalidade) VALUES (11, 11, 0.3);

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
