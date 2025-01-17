--Stergere coloane din tabele
ALTER TABLE clienti_cinema DROP COLUMN  ora_plata_efectuata;


ALTER TABLE filme DROP CONSTRAINT film_rating;
ALTER TABLE pret_variabil_bilete DROP CONSTRAINT interval_orar_pozitiv;
ALTER TABLE sali_cinema DROP CONSTRAINT nr_max_sala;
ALTER TABLE angajati_cinema DROP CONSTRAINT email_valid;
ALTER TABLE produse_cumparate DROP CONSTRAINT prod_mai_mare_ca_zero;
ALTER TABLE stoc_lunar_cinema DROP CONSTRAINT luna_valida;
ALTER TABLE stoc_lunar_cinema DROP CONSTRAINT stoc_mai_mare_ca_zero;
ALTER TABLE roluri_angajati_cinema DROP CONSTRAINT rol_tura_valida;
ALTER TABLE recenzii_filme DROP CONSTRAINT rec_rating;
ALTER TABLE angajati_cinema DROP CONSTRAINT unic_angajat;
ALTER TABLE distributie_filme DROP CONSTRAINT unic_film_actor;

--Adaugare coloane tabele
ALTER TABLE clienti_cinema ADD ora_plata_efectuata TIMESTAMP DEFAULT SYSDATE;

--rating-ul trebuie sa fie intre 1.0 si 5.0
ALTER TABLE filme
ADD CONSTRAINT film_rating CHECK (rating BETWEEN 1.0 AND 5.0);

--Evitare duplicare de date in tabelul distributie_filme
ALTER TABLE distributie_filme
ADD CONSTRAINT unic_film_actor UNIQUE (id_film, id_actor);

--Durata pretului schimbat trebuie sa fie pozitiva
ALTER TABLE pret_variabil_bilete
ADD CONSTRAINT interval_orar_pozitiv CHECK (interv_oral_pret > INTERVAL '0' DAY);

--Nr. maxim de personane dintr-o sala: 100
ALTER TABLE sali_cinema
ADD CONSTRAINT nr_max_sala CHECK (nr_locuri <= 100);

--Validare structura email angajati
ALTER TABLE angajati_cinema
ADD CONSTRAINT email_valid CHECK (REGEXP_LIKE(email , '[[:alnum:]]+\.[[:alnum:]]+@cinema\.ro') OR REGEXP_LIKE(email, '[[:alnum:]]+@stud\.ase\.ro') );

--Asigurarea faptului ca un angajat este unic in baza de date: nr_tel unic + email unic
ALTER TABLE angajati_cinema
ADD CONSTRAINT unic_angajat UNIQUE (nr_telefon, email);

--Cantitatea produselor trebuie sa fie mai mare ca zero
ALTER TABLE produse_cumparate
ADD CONSTRAINT prod_mai_mare_ca_zero CHECK (cantitate_produs > 0);

--Luna aferenta stocului trebuie sa apartina ianuarie-decembrie (12 luni)
ALTER TABLE stoc_lunar_cinema
ADD CONSTRAINT luna_valida CHECK (luna BETWEEN 1 AND 12);


--Cantitatea ceruta trebuie sa fie mereu pozitiva
ALTER TABLE stoc_lunar_cinema
ADD CONSTRAINT stoc_mai_mare_ca_zero CHECK (cantitate_ceruta > 0);

-- inceputul turei trebuie sa fie inaintea finalului turei de lucru
ALTER TABLE roluri_angajati_cinema
ADD CONSTRAINT rol_tura_valida CHECK (incepere_tura < final_tura);


--rating-ul trebuie sa fie intre 1.0 si 5.0
ALTER TABLE recenzii_filme
ADD CONSTRAINT rec_rating CHECK (rating BETWEEN 1.0 AND 5.0);






