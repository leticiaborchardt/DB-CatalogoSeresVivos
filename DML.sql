SET search_path TO SeresVivos;

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