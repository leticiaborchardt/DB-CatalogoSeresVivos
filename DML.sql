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



-- Casos de uso (extra):

-- 3. Biólogo Conservacionista Analisando o Status de Conservação de Répteis
SELECT
    DISTINCT(e.nome_cientifico),
    e.nome_comum,
    e.status_conservacao,
    e.descricao
FROM especie e
INNER JOIN genero g ON e.id_genero = g.id
INNER JOIN familia f ON g.id_familia = f.id
INNER JOIN ordem o ON f.id_ordem = o.id
INNER JOIN especie_localizacao el ON e.id = el.id_especie
INNER JOIN localizacao l ON el.id_localizacao = l.id
INNER JOIN localizacao_bioma lb ON l.id = lb.id_localizacao
INNER JOIN bioma b ON lb.id_bioma = b.id
WHERE
    o.nome = 'Squamata'
    AND f.nome = 'Viperidae'
    AND b.nome = 'Caatinga'
    AND (e.status_conservacao = 'Vulnerável' OR e.status_conservacao = 'Em Perigo');

-- 4. Biólogo Evolutivo Estudando a Diversificação de Aves
SELECT
    f.nome AS familia,
    g.nome AS genero,
    ST_Z(l.regiao::geometry) AS altitude,
    COUNT(e.id) AS numero_de_especies
FROM especie e
INNER JOIN genero g ON e.id_genero = g.id
INNER JOIN familia f ON g.id_familia = f.id
INNER JOIN ordem o ON f.id_ordem = o.id
INNER JOIN classe c ON o.id_classe = c.id
INNER JOIN especie_localizacao el ON e.id = el.id_especie
INNER JOIN localizacao l ON el.id_localizacao = l.id
WHERE c.nome = 'Aves' AND f.nome = 'Tyrannidae'
GROUP BY f.nome, g.nome, altitude
ORDER BY altitude, g.nome;

-- Views extras
SELECT * FROM view_especies_por_localizacao;