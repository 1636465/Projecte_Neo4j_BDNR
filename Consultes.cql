// Consulta 1
MATCH (h:Habitatge {anyPadro: datetime("1866"), municipi: "CR"}) <— [:VIU] — (i:Individual)
RETURN COUNT(i), collect(i.cognom)

// Consulta 2

// Consulta 3

// Consulta 4

// Consulta 5

// Consulta 6

// Consulta 7

// Consulta 8

// Consulta 9

// Consulta 10 

// Consulta 11 

// Consulta 12

// Consulta 13
