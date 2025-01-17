DROP TABLE produse_cumparate CASCADE CONSTRAINTS;
DROP TABLE stoc_lunar_cinema CASCADE CONSTRAINTS;
DROP TABLE clienti_cinema CASCADE CONSTRAINTS;
DROP TABLE derulari_filme CASCADE CONSTRAINTS;
DROP TABLE bilete_cinema CASCADE CONSTRAINTS;
DROP TABLE distributie_filme CASCADE CONSTRAINTS;
DROP TABLE produse_cinema CASCADE CONSTRAINTS;
DROP TABLE sali_cinema CASCADE CONSTRAINTS;
DROP TABLE filme CASCADE CONSTRAINTS;
DROP TABLE angajati_cinema CASCADE CONSTRAINTS;
DROP TABLE departamente_cinema CASCADE CONSTRAINTS;
DROP TABLE actori CASCADE CONSTRAINTS;
DROP TABLE pret_variabil_bilete CASCADE CONSTRAINTS;
DROP TABLE roluri_angajati_cinema CASCADE CONSTRAINTS;
DROP TABLE recenzii_filme CASCADE CONSTRAINTS;

CREATE TABLE actori(
    id NUMBER(3,0) ,
    nume VARCHAR2(50) NOT NULL ,
    prenume VARCHAR2(50) NOT NULL
);

--Actor pk
ALTER TABLE actori 
ADD CONSTRAINT actor_pk PRIMARY KEY (id);


CREATE TABLE filme(
    id NUMBER(3,0),
    nume VARCHAR2(200) NOT NULL,
    gen VARCHAR2(50) NOT NULL,
    data_lansare DATE NOT NULL,
    durata number(3,0) NOT NULL,
    rating number(2,1) DEFAULT NULL
);


--Film pk
ALTER TABLE filme
ADD CONSTRAINT film_pk PRIMARY KEY (id);

CREATE TABLE distributie_filme(
    id_actor NUMBER(3,0) NOT NULL, 
    id_film NUMBER(3,0) NOT NULL,
    CONSTRAINT actor_fk FOREIGN KEY (id_actor) REFERENCES actori(id),
    CONSTRAINT film_fk FOREIGN KEY  (id_film) REFERENCES filme(id)
);

CREATE TABLE sali_cinema (
    id NUMBER(3,0), 
    nr_sala NUMBER(2,0) CONSTRAINT nr_sala_nn NOT NULL,
    nr_locuri NUMBER(3,0) CONSTRAINT nr_locuri_nn NOT NULL
);

--Sala cinema pk
ALTER TABLE sali_cinema
ADD CONSTRAINT sala_cinema_pk PRIMARY KEY (id);

CREATE TABLE departamente_cinema (
    id NUMBER(3,0),
    nume VARCHAR2(50) NOT NULL
);

--Departament cinema pk
ALTER TABLE departamente_cinema
ADD CONSTRAINT dep_cinema_pk PRIMARY KEY (id);


CREATE TABLE angajati_cinema (
    id_angajat NUMBER(3,0) PRIMARY KEY, 
    id_manager NUMBER(3,0),
    nume VARCHAR2(50) NOT NULL, 
    prenume VARCHAR2(50) NOT NULL,
    nr_telefon VARCHAR2(12) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    salariul NUMBER(4,0) NOT NULL,
    id_departament NUMBER(3,0),
    CONSTRAINT manager_fk_cinema FOREIGN KEY (id_manager) REFERENCES angajati_cinema(id_angajat)
);

ALTER TABLE angajati_cinema
ADD CONSTRAINT ang_dep_fk FOREIGN KEY (id_departament) REFERENCES departamente_cinema(id);

CREATE TABLE bilete_cinema (
    id NUMBER(3,0), 
    pret_unitar NUMBER(5,2) NOT NULL,
    id_film NUMBER(3,0),
    CONSTRAINT film_bilet_fk  FOREIGN KEY (id_film) REFERENCES filme(id)

);



--Bilet cinema pk
ALTER TABLE bilete_cinema 
ADD CONSTRAINT bilet_cinema_pk PRIMARY KEY (id);

CREATE TABLE derulari_filme (
    id NUMBER(3,0),
    id_film NUMBER(3,0) NOT NULL, 
    id_sala NUMBER(3,0) NOT NULL, 
    ora_derulare TIMESTAMP WITH LOCAL TIME ZONE NOT NULL,
    CONSTRAINT film_derulare_film_fk  FOREIGN KEY (id_film) REFERENCES filme(id),
    CONSTRAINT sala_derulare_film_fk FOREIGN KEY  (id_sala) REFERENCES sali_cinema(id)
);

--Derulare film pk
ALTER TABLE derulari_filme
ADD CONSTRAINT id_der_film_pk PRIMARY KEY (id);

CREATE TABLE produse_cinema(
    id NUMBER(3,0), 
    pret_unitar NUMBER(5,2) NOT NULL,
    nume VARCHAR2(30) NOT NULL
);

--Produs cinema pk
ALTER TABLE produse_cinema
ADD CONSTRAINT produs_cinema_pk PRIMARY KEY (id);

CREATE TABLE clienti_cinema (
    id NUMBER(3,0), 
    id_bilet NUMBER(3,0) NOT NULL, 
    id_derulare_film NUMBER(3,0) NOT NULL, 
    tip_plata VARCHAR2(20) NOT NULL,
    CONSTRAINT client_bilet_fk FOREIGN KEY (id_bilet) REFERENCES bilete_cinema(id) ,
    CONSTRAINT client_derulare_film_fk  FOREIGN KEY (id_derulare_film)  REFERENCES derulari_filme(id)
);

--Client cinema pk
ALTER TABLE clienti_cinema
ADD CONSTRAINT client_cinema_pk PRIMARY KEY (id);

CREATE TABLE produse_cumparate(
    id NUMBER(3,0), 
    id_client NUMBER(3,0),
    id_produs NUMBER(3,0), 
    cantitate_produs NUMBER(3,0) NOT NULL,
    CONSTRAINT tip_produs_cinema_fk FOREIGN KEY (id_produs) REFERENCES produse_cinema(id),
    CONSTRAINT client_produs_cumparat_fk FOREIGN KEY (id_client) REFERENCES clienti_cinema(id)
);

--Produs cumparat pk
ALTER TABLE produse_cumparate
ADD CONSTRAINT prod_cump_cinema_pk PRIMARY KEY(id);

CREATE TABLE stoc_lunar_cinema (
    id NUMBER(3,0),
    luna NUMBER(2,0) NOT NULL,
    an NUMBER(4,0) NOT NULL,
    cantitate_ceruta NUMBER(3,0) NOT NULL,
    tip_produs NUMBER(3,0),
    CONSTRAINT tip_produs_fk FOREIGN KEY (tip_produs) REFERENCES produse_cinema(id)
); 

--Stoc lunar cinema pk
ALTER TABLE stoc_lunar_cinema
ADD CONSTRAINT stoc_l_cin_pk PRIMARY KEY (id);


CREATE TABLE pret_variabil_bilete (
    id NUMBER(3,0),
    id_bilet NUMBER(3,0),
    zi_schimbare_pret DATE DEFAULT SYSDATE,
    interv_oral_pret INTERVAL DAY TO SECOND NOT NULL,
    pret_ajustat NUMBER(3,0),
    eveniment_special VARCHAR2(70),
    CONSTRAINT pret_variabil_bilete_fk FOREIGN KEY (id) REFERENCES bilete_cinema(id)
);

--pret variabil bilet pk
ALTER TABLE pret_variabil_bilete
ADD CONSTRAINT pret_variabil_bilete_pk PRIMARY KEY (id);

CREATE TABLE roluri_angajati_cinema (
    id_angajat NUMBER(3,0),
    rol VARCHAR2(50) NOT NULL,
    incepere_tura TIMESTAMP  NOT NULL,
    final_tura TIMESTAMP NOT NULL,
    CONSTRAINT rol_ang_fk FOREIGN KEY (id_angajat) REFERENCES angajati_cinema(id_angajat)
); 

--rol angajat pk
ALTER TABLE roluri_angajati_cinema
ADD CONSTRAINT rol_ang_pk PRIMARY KEY (id_angajat, rol);


CREATE TABLE recenzii_filme (
    id NUMBER(3,0),
    id_client NUMBER(3,0),
    id_film NUMBER(3,0),
    text_recenzie VARCHAR2(500),
    rating NUMBER(2,1),
    CONSTRAINT recenzie_client_fk FOREIGN KEY (id_client) REFERENCES clienti_cinema(id),
    CONSTRAINT recenzie_film_fk FOREIGN KEY (id_film) REFERENCES filme(id)
);

--recenzie film pk
ALTER TABLE recenzii_filme
ADD CONSTRAINT rec_film_pk PRIMARY KEY (id);

