// Creació nodes Habitatge
LOAD CSV WITH HEADERS FROM 'file:///HABITATGES.csv' as row
WITH toInteger(row.Id_Llar) AS idLlar, row.Municipi AS municipi, datetime(replace(row.Any_Padro,' ','T')) AS anyPadro, row.Carrer AS carrer, toInteger(row.Numero) AS numero 
WHERE idLlar <> "null" AND municipi <> "null"
MERGE (h:Habitatge {idLlar: idLlar, municipi: municipi})
ON CREATE SET h.anyPadro = anyPadro, h.carrer = carrer, h.numero = numero
WITH h
return h.idLlar, h.municipi, h.anyPadro, h.carrer, h.numero
limit 10;

// Creació nodes Individual
LOAD CSV WITH HEADERS FROM 'file:///INDIVIDUAL.csv' AS row
WITH toInteger(row.Id) AS id, datetime(replace(row.Year,' ','T')) AS any, row.name AS nom, row.surname AS cognom, row.second_surname AS cognom2
WHERE id <> "null"
MERGE (i:Individual {id: id})
ON CREATE SET i.any = any, i.nom = nom, i.cognom = cognom, i.cognom2 = cognom2
WITH i
return i.id, i.any, i.nom, i.cognom, i.cognom2
limit 10;

// Creació relacions FAMILIA
LOAD CSV WITH HEADERS FROM 'file:///FAMILIA.csv' as row
WITH toInteger(row.ID_1) AS id1, toInteger(row.ID_2) AS id2, row.Relacio AS relacio, row.Relacio_Harmonitzada AS relacioH
WHERE id1 <> "null" AND id2 <> "null"
MATCH (p1:Individual {id: id1})
MATCH (p2:Individual {id: id2})
MERGE (p1)-[rel:FAMILIA {relacio: relacio, relacioH: relacioH}]->(p2)
WITH p1, p2, rel
return p1.id, rel.relacio, rel.relacioH, p2.id
limit 10;

// Creació relacions SAME_AS
LOAD CSV WITH HEADERS FROM 'file:///SAME_AS.csv' AS row
WITH toInteger(row.Id_A) AS idA, toInteger(row.Id_B) AS idB
MATCH (p1:Individual {id: idA})
MATCH (p2:Individual {id: idB})
MERGE (p1)-[rel:SAME_AS]->(p2)
WITH p1, p2
return p1.id, p2.id
limit 10;

// Creació relacions VIU
LOAD CSV WITH HEADERS FROM 'file:///VIU.csv' AS row
WITH toInteger(row.IND) AS ind, datetime(replace(row.Year,' ','T')) AS anyViu,
toInteger(row.HOUSE_ID) AS idCasa, row.Location AS ubi
MATCH (p:Individual {id: ind, any: anyViu})
MATCH (h:Habitatge {municipi: ubi, idLlar: idCasa, anyPadro: anyViu})
MERGE (p)-[rel:VIU]->(h)
WITH p, h
return p.id, h.municipi, p.any, h.anyPadro, h.idLlar
limit 10;

// Mirem l'esquema del graf
CALL db.schema.visualization()

// Creació de constraints
CREATE CONSTRAINT UniqueidIndividualConstraint 
FOR (i:Individual) REQUIRE i.id IS UNIQUE

CREATE CONSTRAINT ExistsIndId FOR (i:Individual) REQUIRE i.id IS NOT NULL

CREATE CONSTRAINT ExistsIdhabitatge 
FOR (h:Habitatge) REQUIRE h.idLlar IS NOT NULL

CREATE CONSTRAINT Existsmunicipihabitatge 
FOR (h:Habitatge) REQUIRE h.municipi IS NOT NULL

CREATE CONSTRAINT UniqueIdMunicipiConstraint 
FOR  (h:Habitatge)  REQUIRE (h.idLlar, h.municipi) IS NODE KEY


