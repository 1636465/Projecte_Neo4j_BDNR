//Exercici_3
//Apartat a
//Apartat B
//Punt_1
MATCH (h1:Habitatge), (h2:Habitatge)
WHERE h1.municipi = h2.municipi AND h1.idLlar = h2.idLlar AND h1.anyPadro <> h2.anyPadro
WITH h1, h2, CASE WHEN h1.anyPadro > h2.anyPadro THEN h2 ELSE h1 END AS nodeApuntat, CASE WHEN h1.anyPadro > h2.anyPadro THEN h1 ELSE h2 END AS nodeApunta
MERGE (nodeApunta)-[r:MATEIX_HAB]->(nodeApuntat)
RETURN nodeApunta.municipi, nodeApunta.idLlar, nodeApunta.anyPadro, nodeApuntat.municipi, nodeApuntat.idLlar, nodeApuntat.anyPadro

//Punt_2
//Punt_3

