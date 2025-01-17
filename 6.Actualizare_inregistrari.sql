UPDATE clienti_cinema cc
SET cc.ora_plata_efectuata = (
    SELECT df.ora_derulare - INTERVAL '10' MINUTE
    FROM derulari_filme df
    WHERE cc.id_derulare_film = df.id
      AND cc.ora_plata_efectuata >= df.ora_derulare
)
WHERE EXISTS (
    SELECT 1
    FROM derulari_filme df
    WHERE cc.id_derulare_film = df.id
      AND cc.ora_plata_efectuata>= df.ora_derulare
); 

DELETE FROM clienti_cinema 
WHERE id = 20; 
