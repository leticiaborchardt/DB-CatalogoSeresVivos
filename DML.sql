SET search_path TO SeresVivos;

-- 2.a) Quais doenças acometem principalmente primatas em áreas de desmatamento?
SELECT d.nome, d.descricao
FROM doenca d
INNER JOIN especie_doenca ed ON d.id = ed.id_doenca
INNER JOIN especie e ON ed.id_especie = e.id
INNER JOIN especie_localizacao el ON e.id = el.id_especie
INNER JOIN localizacao l ON el.id_localizacao = l.id
INNER JOIN genero g ON e.id_genero = g.id
INNER JOIN familia f ON g.id_familia = f.id
INNER JOIN ordem o ON f.id_ordem = o.id
WHERE l.area_protegida = FALSE AND o.nome = 'Primates';

-- 2.b) Qual a taxa de mortalidade por determinada doença em uma espécie específica?
SELECT ed.taxa_mortalidade 
FROM especie_doenca ed
INNER JOIN especie e ON ed.id_especie = e.id
WHERE e.nome_cientifico = 'Panthera leo'

-- 3.a) Quais são os gêneros mais diversos da família Felidae?
SELECT g.nome 
FROM genero g
INNER JOIN familia f ON g.id_familia = f.id
WHERE f.nome = 'Felidae';

-- 4.a) Qual a evolução da população de uma espécie ao longo dos anos?
SELECT 
    he.data_hora, 
    he.ultima_populacao 
FROM 
    historico_especie he
INNER JOIN 
    especie e ON he.id_especie = e.id
WHERE 
    e.nome_cientifico = 'Turdus merula'
ORDER BY 
    he.data_hora;

-- 4.b) Quais são as áreas prioritárias para conservação de uma determinada espécie?
SELECT 
    l.nome AS area, 
    l.regiao 
FROM 
    localizacao l
INNER JOIN 
    especie_localizacao el ON l.id = el.id_localizacao
INNER JOIN 
    especie e ON el.id_especie = e.id
WHERE 
    e.nome_cientifico = 'Panthera leo' 
    AND l.area_protegida = TRUE;