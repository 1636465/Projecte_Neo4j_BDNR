// Consulta 1
MATCH (h:Habitatge {anyPadro: datetime("1866"), municipi: "CR"}) <— [:VIU] — (i:Individual)
RETURN COUNT(i), collect(i.cognom)

// Consulta 2
MATCH (p:Individual)-[:VIU]->(h:Habitatge {municipi: 'SFLL'})
WHERE p.cognom IS NOT NULL AND p.cognom <> 'nan' 
RETURN h.anyPadro AS anyPadro,count(p) AS numHabitants, collect(DISTINCT p.cognom) AS cognoms

// Consulta 3

// Consulta 4

// Consulta 5
MATCH (i:Individual)-[:SAME_AS]-(i2: Individual) 
WHERE i.nom = "miguel" AND i.cognom = "estape" AND i.cognom2 = "bofill"
RETURN i, i2

// Consulta 6

// Consulta 7
MATCH (p:Individual)-[r]->(rel:Individual)
WHERE p.nom = 'benito' AND p.cognom = 'julivert'
RETURN rel.nom AS Nom, rel.cognom AS Cognom1, rel.cognom2 AS Cognom2, type(r) AS TipusRelacio

// Consulta 8

// Consulta 9

// Consulta 10 
MATCH (h:Habitatge)
WHERE h.carrer IS NOT NULL AND h.numero IS NOT NULL AND h.municipi = "SFLL"
WITH h.carrer AS carrer, h.numero AS numero, count(*) AS totalPadrons, collect(DISTINCT h.anyPadro) AS anysPadro, collect(DISTINCT h.idLlar) AS idsLlar
RETURN carrer, numero, totalPadrons, anysPadro, idsLlar
ORDER BY totalPadrons DESC
LIMIT 15

// Consulta 11 
MATCH (h:Habitatge)-[:VIU]-(i:Individual)-[fam:FAMILIA]->(f:Individual)
WHERE h.municipi = "CR" AND (fam.relacio CONTAINS "hij" OR fam.relacioH CONTAINS "fill")
WITH i, count(f) AS num_fills
WHERE num_fills > 3
RETURN i.nom AS nom_cap_familia, i.cognom AS cognom_cap_familia, num_fills
ORDER BY num_fills DESC
LIMIT 20

// Consulta 12

// Consulta 13
