// Creació nodes Habitatge
LOAD CSV WITH HEADERS FROM 'file:///HABITATGES.csv' as row
WITH toInteger(row.Id_Llar) AS idLlar, row.Municipi AS municipi, datetime(replace(row.Any_Padro,' ','T')) AS anyPadro, row.Carrer AS carrer, toInteger(row.Numero) AS numero 
WHERE idLlar IS NOT NULL AND municipi IS NOT NULL 
MERGE (h:Habitatge {idLlar: idLlar})
SET h.municipi = municipi, h.anyPadro = anyPadro, h.carrer = carrer, h.numero = numero
return idLlar, municipi, anyPadro, carrer, numero
limit 10;

// Creació nodes Individual
LOAD CSV WITH HEADERS FROM 'file:///INDIVIDUAL.csv' AS row
WITH toInteger(row.Id) AS id, datetime(replace(row.Year,' ','T')) AS any, row.name AS nom, row.surname AS cognom, row.second_surname AS cognom2
WHERE id IS NOT NULL
MERGE (i:Individual {id: id})
SET i.any = any, i.name = name, i.cognom = cognom, i.cognom2 = cognom2
return id, any, nom,cognom, cognom2
limit 10;

// Creació relacions FAMILIA
LOAD CSV WITH HEADERS FROM 'file:///FAMILIA.csv' as row
WITH toInteger(row.ID_1) AS id1, toInteger(row.ID_2) AS id2, row.Relacio AS relacio, row.Relacio_Harmonitzada AS relacioH
WHERE id1 IS NOT NULL AND id2 IS NOT NULL 
MATCH (p1:Invidual {id: id1})
MATCH (p2:Individual {id: id2})
MERGE (p1)-[rel:FAMILIA {relacio: relacio, relacioH: relacioH}]->(p2)
return id1, relacio, relacioH, id2
limit 10;

// Creació relacions SAME_AS
LOAD CSV WITH HEADERS FROM 'file:///SAME_AS.csv' AS row
WITH toInteger(row.Id_A) AS idA, toInteger(row.Id_B) AS idB
MATCH (p1:Individual {id: idA})
MATCH (p2:Individual {id: idB})
MERGE (p1)-[rel:SAME_AS]->(p2)
return idA, idB
limit 10;

// Creació relacions VIU
LOAD CSV WITH HEADERS FROM 'file:///VIU.csv' AS row
WITH toInteger(row.IND) AS ind, datetime(replace(row.Year,' ','T')) AS anyViu,
toInteger(row.HOUSE_ID) AS idCasa, row.Location AS ubi
MATCH (p:Individual {id: ind, any: anyViu})
MATCH (h:Habitatge {municipi: ubi, idLlar: idCasa})
MERGE (p)-[rel:VIU]->(h)
return ind, ubi, anyViu, idCasa
limit 10;
