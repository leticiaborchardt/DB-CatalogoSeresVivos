SET search_path TO SeresVivos;

-- 1) Distribuição Geográfica e Ecologia
-- 1.a) Quais espécies de aves migratórias passam pela Amazônia brasileira?
SELECT e.nome_comum
FROM Especie e
INNER JOIN Genero gen ON gen.id = e.id_genero
INNER JOIN Familia f ON f.id = gen.id_familia
INNER JOIN Ordem o ON f.id_ordem = o.id
INNER JOIN Classe cla ON cla.id = o.id_classe
INNER JOIN especie_localizacao el ON e.id = el.id_especie
INNER JOIN Localizacao l ON el.id_localizacao = l.id
INNER JOIN localizacao_bioma lb ON lb.id_localizacao = l.id
INNER JOIN Bioma b ON lb.id_bioma = b.id
WHERE cla.nome = 'Aves' AND b.nome = 'Amazônia' 
        AND (
        SELECT COUNT(DISTINCT el2.id_localizacao)
        FROM especie_localizacao el2
        WHERE el2.id_especie = e.id
        ) > 1;

-- 1.b) Qual a densidade populacional de onças-pintadas em áreas protegidas do Cerrado?
SELECT SUM(el.populacao_local) as densidade_areas_protegidas
FROM especie e
INNER JOIN especie_localizacao el ON el.id_especie = e.id
INNER JOIN localizacao l ON el.id_localizacao = l.id
INNER JOIN localizacao_bioma lb ON lb.id_localizacao = l.id
INNER JOIN bioma b ON b.id = lb.id_bioma
WHERE b.nome = 'Cerrado' AND area_protegida = TRUE AND e.nome_comum = 'Onça-pintada'

-- 1.c) Quais espécies de plantas são endêmicas da Mata Atlântica e estão ameaçadas de extinção?
SELECT e.nome_cientifico, e.nome_comum
FROM Especie e
INNER JOIN Genero gen ON gen.id = e.id_genero
INNER JOIN Familia f ON f.id = gen.id_familia
INNER JOIN Ordem o ON f.id_ordem = o.id
INNER JOIN Classe cla ON cla.id = o.id_classe
INNER JOIN filo fi ON fi.id = cla.id_filo
INNER JOIN reino r ON fi.id_reino = r.id
INNER JOIN especie_localizacao el ON e.id = el.id_especie
INNER JOIN Localizacao l ON el.id_localizacao = l.id
INNER JOIN localizacao_bioma lb ON lb.id_localizacao = l.id
INNER JOIN Bioma b ON lb.id_bioma = b.id
WHERE r.nome = 'Plantae'
	AND (
		e.status_conservacao = 'Vulnerável'
		OR e.status_conservacao = 'Em Perigo'
		OR e.status_conservacao = 'Criticamente em Perigo'
	)
	AND b.nome = 'Amazônia'
	AND NOT EXISTS (
        SELECT 1
        FROM localizacao_bioma lb2
        INNER JOIN Localizacao l2 ON lb2.id_localizacao = l2.id
        INNER JOIN especie_localizacao el2 ON l2.id = el2.id_localizacao
        WHERE el2.id_especie = e.id
        AND lb2.id_bioma != b.id
    );

-- 2) Doenças e Saúde Animal
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

-- 3) Evolução e Filogenia
-- 3.a) Quais são os gêneros mais diversos da família Felidae?
SELECT g.nome 
FROM genero g
INNER JOIN familia f ON g.id_familia = f.id
WHERE f.nome = 'Felidae';

-- 4) Monitoramento e Conservação
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
-- 1. Biólogo Estudando a Impacto do Desmatamento em Primatas:
SELECT
    d.nome AS doenca,
    d.descricao,
    ed.taxa_mortalidade
FROM
    doenca d
        INNER JOIN
    especie_doenca ed ON d.id = ed.id_doenca
        INNER JOIN
    especie e ON ed.id_especie = e.id
        INNER JOIN
    especie_localizacao el ON e.id = el.id_especie
        INNER JOIN
    localizacao l ON el.id_localizacao = l.id
        INNER JOIN
    genero g ON e.id_genero = g.id
        INNER JOIN
    familia f ON g.id_familia = f.id
        INNER JOIN
    ordem o ON f.id_ordem = o.id
WHERE
    l.area_protegida = FALSE
  AND o.nome = 'Primates';

-- 2. Bióloga Estudando a Distribuição Geográfica de Uma Espécie Invasora:
SELECT
    e.nome_cientifico AS especie_nativa,
    e.nome_comum AS nome_comum_nativa,
    ie.tipo AS tipo_interacao,
    ie.descricao AS descricao_interacao
FROM
    especie e
        INNER JOIN
    especie_localizacao el ON e.id = el.id_especie
        INNER JOIN
    localizacao l ON el.id_localizacao = l.id
        INNER JOIN
    interacao_ecologica ie ON e.id = ie.id_especie1 OR e.id = ie.id_especie2
WHERE
    l.nome = 'Rio X'
  AND e.id != (SELECT id FROM especie WHERE nome_cientifico = 'Pterygoplichthys pardalis')
  AND (ie.id_especie1 = (SELECT id FROM especie WHERE nome_cientifico = 'Pterygoplichthys pardalis')
    OR ie.id_especie2 = (SELECT id FROM especie WHERE nome_cientifico = 'Pterygoplichthys pardalis'));

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