// Consulta 1
MATCH (h:Habitatge {anyPadro: datetime("1866"), municipi: "CR"}) <— [:VIU] — (i:Individual)
RETURN COUNT(i), collect(i.cognom)

// Consulta 2
MATCH (p:Individual)-[:VIU]->(h:Habitatge {municipi: 'SFLL'})
WHERE p.cognom IS NOT NULL AND p.cognom <> 'nan' 
RETURN h.anyPadro AS anyPadro,count(p) AS numHabitants, collect(DISTINCT p.cognom) AS cognoms

// Consulta 3
MATCH  (h:Habitatge{municipi:"SFLL"})
WHERE datetime(h.anyPadro).year > 1800 AND datetime(h.anyPadro).year < 1845
RETURN h.municipi AS Poblacio, datetime(h.anyPadro).year AS anyPadro, COLLECT(h.idLlar) AS identificadorsHabitatges
ORDER BY anyPadro

// Consulta 4

MATCH (p:Individual)-[:VIU]->(h:Habitatge)
WHERE p.name="rafel" AND p.surname = "marti" AND p.second_surname= "nan" AND h.municipi = "SFLL" AND datetime(h.anyPadro).year = 1838 
MATCH (h)<-[:VIU]-(other:Individual)
RETURN other.name

// Consulta 5
MATCH (i:Individual)-[:SAME_AS]-(i2: Individual) 
WHERE i.nom = "miguel" AND i.cognom = "estape" AND i.cognom2 = "bofill"
RETURN i, i2

// Consulta 6
MATCH (i:Individual)-[:SAME_AS]-(i2:Individual)
WHERE i.nom = "miguel" AND i.cognom = "estape" AND i.cognom2 = "bofill"
RETURN DISTINCT i.nom AS nom, COLLECT(DISTINCT i2.cognom) AS cognoms, COLLECT(DISTINCT i2.cognom2) AS cognoms2

// Consulta 7
MATCH (p:Individual)-[r:FAMILIA]->(rel:Individual)
WHERE p.nom = 'benito' AND p.cognom = 'julivert'
RETURN rel.nom AS Nom, rel.cognom AS Cognom1, rel.cognom2 AS Cognom2, r.relacioH AS TipusRelacio
        
// Consulta 8

// Consulta 9
MATCH (p1)-[rel:FAMILIA]->(p2)
WHERE rel.relacioH <> "null"
RETURN  collect(DISTINCT(rel.relacioH)) AS Relacions

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
CALL {
  MATCH (h:Habitatge {municipi: "SFLL", anyPadro: datetime("1881-01-01T00:00:00Z")})
  WITH COUNT(DISTINCT h) AS nombreHabitatges
  RETURN nombreHabitatges
} 

MATCH (h:Habitatge {municipi: "SFLL", anyPadro:
datetime("1881-01-01T00:00:00Z")})<-[:VIU]-(i:Individual)
WHERE (((i)-[:FAMILIA {relacio: "hijo"}]->() OR (i)-[:FAMILIA {relacio: "hija"}]->()) OR ((i)-[:FAMILIA {relacioH: "fill"}]->() OR (i)-[:FAMILIA {relacioH: "filla"}]->())) OR  (((i)-[:FAMILIA {relacio: "hijo"}]->() OR (i)-[:FAMILIA {relacio: "hija"}]->()) AND ((i)-[:FAMILIA {relacioH: "fill"}]->() OR (i)-[:FAMILIA {relacioH: "filla"}]->()))
WITH COUNT(i) AS totalFillsPerHabitatge, nombreHabitatges
RETURN totalFillsPerHabitatge, nombreHabitatges,
toFloat(totalFillsPerHabitatge)/toFloat(nombreHabitatges) AS mitjanaFillsPerHabitatge

// Consulta 13
MATCH (i:Individual)-[:VIU]->(h:Habitatge)
WHERE h.municipi = 'SFLL'
WITH h.anyPadro AS anyPadro, h.carrer AS carrer, COUNT(i) AS numHabitantes
ORDER BY anyPadro ASC, numHabitantes ASC
WITH anyPadro, COLLECT({carrer: carrer, numHabitantes: numHabitantes})[0] AS carrerMenosHabitantes
CALL {
        WITH carrerMenosHabitantes
        RETURN carrerMenosHabitantes.carrer AS Carrer, carrerMenosHabitantes.numHabitantes AS NumHabitantes
        ORDER BY carrerMenosHabitantes.carrer ASC
      }
RETURN datetime(anyPadro).year as Year, Carrer, NumHabitantes
ORDER BY anyPadro ASC
