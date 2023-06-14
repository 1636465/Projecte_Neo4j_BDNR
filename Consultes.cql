// Consulta 1
MATCH (h:Habitatge {anyPadro: datetime("1866"), municipi: "CR"}) <— [:VIU] — (i:Individual)
RETURN COUNT(i), collect(i.cognom)

// Consulta 2

// Consulta 3

// Consulta 4

// Consulta 5
MATCH (i:Individual)-[:SAME_AS]-(i2: Individual) 
WHERE i.nom = "miguel" AND i.cognom = "estape" AND i.cognom2 = "bofill"
RETURN i, i2

// Consulta 6

// Consulta 7

// Consulta 8

// Consulta 9

// Consulta 10 

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
