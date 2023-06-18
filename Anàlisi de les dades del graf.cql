//Exercici_3
//Apartat a
CALL gds.graph.project('graf',['Habitatge','Individual'],['VIU', 'FAMILIA', 'SAME_AS'])

- Taula agrupant els resultats segons la mida de la cc. 
CALL gds.wcc.stream('graf')
YIELD componentId, nodeId
RETURN componentId, size(collect(nodeId)) AS mida, collect(nodeId) AS nodes
ORDER BY mida DESC

-Distribució de tipus de nodes (Individu o Habitatge) segons la mida de la cc.
CALL gds.wcc.stream('graf')
YIELD nodeId, componentId
WITH componentId, size(collect(DISTINCT(nodeId))) AS mida, collect(nodeId) AS nodes
MATCH(i:Individual),(h:Habitatge)
WHERE id(i) IN nodes AND id(h) IN nodes
RETURN componentId, count(DISTINCT(i)) AS Individu, count(DISTINCT(h)) AS Habitatge
ORDER BY Individu DESC

- Per cada municipi i any el nombre de parelles del tipus: (Individu)—(Habitatge)
MATCH (i:Individual)-[:VIU]->(h:Habitatge)
RETURN h.municipi AS municipi, datetime(h.anyPadro).year AS any, count(*) AS numParelles
ORDER BY municipi, any

- quantes components connexes no estan connectades a cap node de tipus ‘Habitatge’.
CALL gds.wcc.stream('graf')
YIELD nodeId, componentId
WITH gds.util.asNode(nodeId) AS node, componentId
WHERE NOT (node)--(:Habitatge)
RETURN count(DISTINCT componentId) AS numComponentsDisconnected


//Apartat B
//Punt_1
MATCH (h1:Habitatge), (h2:Habitatge)
WHERE h1.municipi = h2.municipi AND h1.idLlar = h2.idLlar AND h1.anyPadro <> h2.anyPadro
WITH h1, h2, CASE WHEN h1.anyPadro > h2.anyPadro THEN h2 ELSE h1 END AS nodeApuntat, CASE WHEN h1.anyPadro > h2.anyPadro THEN h1 ELSE h2 END AS nodeApunta
MERGE (nodeApunta)-[r:MATEIX_HAB]->(nodeApuntat)
RETURN nodeApunta.municipi, nodeApunta.idLlar, nodeApunta.anyPadro, nodeApuntat.municipi, nodeApuntat.idLlar, nodeApuntat.anyPadro

//Punt_2
//Punt_3

