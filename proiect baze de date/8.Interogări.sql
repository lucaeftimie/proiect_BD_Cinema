--1. 
SELECT
    f.nume,
    f.rating,
    df.ora_derulare,
    cu.username
FROM
    filme          f,
    derulari_filme df,
    cinema_user    cu
WHERE
        f.id = df.id_film
    AND df.ora_derulare BETWEEN TO_TIMESTAMP('01-DEC-23 14.00.00', 'DD-MON-YY HH24:MI:SS') AND TO_TIMESTAMP('01-DEC-23 22.00.00', 'DD-MON-YY HH24:MI:SS'
    );

--2.
SELECT
    cc.id,
    cc.tip_plata,
    pc.id_client,
    pcin.nume,
    df.ora_derulare,
    cc.ora_plata_efectuata,
    cu.username
FROM
    clienti_cinema    cc,
    derulari_filme    df,
    produse_cumparate pc,
    cinema_user       cu,
    produse_cinema    pcin
WHERE
        cc.id_derulare_film = df.id
    AND pc.id_client = cc.id
    AND pcin.id = pc.id_produs
    AND lower(pcin.nume) = 'popcorn'
    AND df.ora_derulare < cc.ora_plata_efectuata;

SELECT
    *
FROM
    roluri_angajati_cinema; 

--3.
SELECT
    ex3.*,
    cu.username
FROM
    (
        SELECT
            round(AVG(ang.salariul),
                  2) "Salariu mediu angajati"
        FROM
            (
                SELECT
                    ang_ianuarie.id_angajat,
                    ang_ianuarie.salariul
                FROM
                    (
                        SELECT
                            ac.*,
                            dc.nume
                        FROM
                            angajati_cinema        ac,
                            roluri_angajati_cinema rac,
                            departamente_cinema    dc
                        WHERE
                                ac.id_angajat = rac.id_angajat
                            AND EXTRACT(MONTH FROM rac.incepere_tura) = 1
                            AND dc.id = ac.id_departament
                    ) ang_ianuarie,
                    (
                        SELECT
                            m.*,
                            dc.nume
                        FROM
                            (
                                SELECT
                                    *
                                FROM
                                    angajati_cinema ac1
                                WHERE
                                    EXISTS (
                                        SELECT
                                            1
                                        FROM
                                            angajati_cinema ac2
                                        WHERE
                                            ac1.id_angajat = ac2.id_manager
                                    )
                            )                   m,
                            departamente_cinema dc
                        WHERE
                            m.id_departament = dc.id
                    ) manageri
                WHERE
                        manageri.id_angajat = ang_ianuarie.id_manager
                    AND manageri.id_departament != ang_ianuarie.id_departament
            ) ang
    )           ex3,
    cinema_user cu;

--4.
SELECT
    ex4.*,
    cu.username
FROM
    (
        SELECT
            sc.id AS "id_sala"
        FROM
            (
                (
                    SELECT
                        cc.*
                    FROM
                        clienti_cinema cc,
                        derulari_filme df
                    WHERE
                        df.id = cc.id_derulare_film
                )
                MINUS
                (
                    SELECT DISTINCT
                        cc.*
                    FROM
                        clienti_cinema    cc,
                        produse_cumparate pc
                    WHERE
                        cc.id = pc.id_client
                )
            )              cc2,
            sali_cinema    sc,
            derulari_filme df2
        WHERE
                sc.id = df2.id_sala
            AND cc2.id_derulare_film = df2.id
    )           ex4,
    cinema_user cu;

--5.
SELECT
    ex5.*,
    cu.username
FROM
    (
        SELECT
            dc.id,
            AVG(salariul)
        FROM
            angajati_cinema        ac,
            roluri_angajati_cinema rac,
            departamente_cinema    dc
        WHERE
                rac.id_angajat = ac.id_angajat
            AND dc.id = ac.id_departament
            AND EXTRACT(HOUR FROM(rac.final_tura - rac.incepere_tura)) BETWEEN 2 AND 8
        GROUP BY
            dc.id
    )           ex5,
    cinema_user cu;

--6.
SELECT
    ex6.*,
    cu.username
FROM
    (
        SELECT
            *
        FROM
            (
                SELECT
                    id_angajat,
                    nume,
                    level,
                    sys_connect_by_path(nume, '--->') "ierarhie"
                FROM
                    angajati_cinema
                CONNECT BY
                    PRIOR id_angajat = id_manager
                START WITH id_angajat = 1
            )
        WHERE
            id_angajat IN (
                SELECT
                    ac.id_angajat
                FROM
                    angajati_cinema        ac, roluri_angajati_cinema rac
                WHERE
                        ac.id_angajat = rac.id_angajat
                    AND ( rac.incepere_tura IS NULL
                          OR rac.final_tura IS NULL )
                    AND salariul <= (
                        SELECT
                            AVG(salariul)
                        FROM
                            angajati_cinema
                    )
            )
    )           ex6,
    cinema_user cu;

--7.
SELECT
    ex7.*,
    cu.username
FROM
    (
        SELECT
            f.*
        FROM
            filme             f,
            distributie_filme df,
            actori            a,
            recenzii_filme    rf
        WHERE
                f.id = df.id_film
            AND a.id = df.id_actor
            AND substr(a.nume, 0, 1) = 'D'
            AND rf.id_film = f.id
            AND rf.rating >= 3
            AND ( upper(rf.text_recenzie) LIKE '%GOOD%'
                  OR upper(rf.text_recenzie) LIKE '%AMAZING%'
                  OR upper(rf.text_recenzie) LIKE '%OK%' )
    )           ex7,
    cinema_user cu;

--8.
SELECT
    ex8.*,
    cu.username
FROM
    (
        SELECT
            bc.*,
            sch.*,
            CASE
                WHEN sch.nr_schimbari = 1  THEN
                    'DOAR O OFERTA'
                WHEN sch.nr_schimbari = 2  THEN
                    'PUTINE OFERTE'
                WHEN sch.nr_schimbari >= 3 THEN
                    'OFERTA MAXIMIZATA'
                ELSE
                    'ERROR'
            END "TIP OFERTA"
        FROM
            bilete_cinema bc,
            (
                SELECT
                    id        "ID FILM",
                    COUNT(id) "NR_SCHIMBARI"
                FROM
                    (
                        SELECT
                            f.*
                        FROM
                            filme                f,
                            bilete_cinema        bc,
                            pret_variabil_bilete pvb
                        WHERE
                                f.id = bc.id_film
                            AND bc.id = pvb.id
                    ) pvb2
                GROUP BY
                    id
            )             sch
        WHERE
            bc.id = sch."ID FILM"
    )           ex8,
    cinema_user cu;

--9.
SELECT
    ex9.*,
    cu.username
FROM
    (
        SELECT
            ac.nume,
            ac.prenume,
            to_char(ac.salariul, '$9999.99')
        FROM
            angajati_cinema ac,
            (
                SELECT
                    AVG(ac.salariul) sal_med_dep,
                    ac.id_departament
                FROM
                    angajati_cinema     ac,
                    departamente_cinema dc
                WHERE
                    ac.id_departament = dc.id
                GROUP BY
                    ac.id_departament
                HAVING
                    AVG(ac.salariul) > 1500
            )               avgs
        WHERE
                ac.id_departament = avgs.id_departament
            AND avgs.sal_med_dep > ac.salariul
    )           ex9,
    cinema_user cu;

--10.
SELECT
    ex10.*,
    cu.username
FROM
    (
        SELECT
            *
        FROM
            clienti_cinema
        WHERE
            ( sysdate - ora_plata_efectuata ) * 24 <= numtodsinterval(1, 'HOUR')
    )           ex10,
    cinema_user cu;

--11.
SELECT
    ex11.*,
    cu.username
FROM
    (
        SELECT
            pvb.pret_ajustat - bc.pret_unitar "PRET VARIABIL - PRET BILET",
            nvl(eveniment_special, 'No obvious reason for price change')
        FROM
            bilete_cinema        bc,
            pret_variabil_bilete pvb
        WHERE
            pvb.id_bilet = bc.id
    )           ex11,
    cinema_user cu;

--12.
SELECT
    ex12.*,
    cu.username
FROM
    (
        SELECT
            nrrec.id_film,
            CASE
                WHEN nrrec.numar_recenzii >= 3 THEN
                    'FILM POPULAR'
                WHEN nrrec.numar_recenzii <= 2 THEN
                    'FILM NORMAL'
                ELSE
                    'FILM MISTER'
            END "criteriu film"
        FROM
            (
                SELECT
                    rf.id_film,
                    COUNT(rf.id_film) "NUMAR_RECENZII"
                FROM
                    recenzii_filme rf
                GROUP BY
                    rf.id_film
            ) nrrec
    )           ex12,
    cinema_user cu;

--13.
SELECT
    ex13.*,
    cu.username
FROM
    (
        SELECT
            pc.id_produs,
            COUNT(pc.id_produs) "NR PRODUSE"
        FROM
            produse_cumparate pc,
            produse_cinema    pcin
        WHERE
                pc.id_produs = pcin.id
            AND pcin.pret_unitar >= 15
        GROUP BY
            pc.id_produs
    )           ex13,
    cinema_user cu;

--14.
SELECT
    ex14.*,
    cu.username
FROM
    (
        SELECT
            rf2.*,
            CASE
                WHEN rf2."NR_RECENZII" <= 3 THEN
                    'Film fara gustare  nesatisfacator'
                WHEN rf2."NR_RECENZII" >= 7 THEN
                    'Film cu gustare satisfacator'
                ELSE
                    NULL
            END "Legatura film gustare"
        FROM
            (
                SELECT
                    rf.id_client,
                    COUNT(rf.id_client) "NR_RECENZII"
                FROM
                    (
                        (
                            SELECT
                                cl_f_p.id,
                                NULL AS "NR_PRODUSE"
                            FROM
                                (
                                    (
                                        SELECT
                                            *
                                        FROM
                                            clienti_cinema
                                    )
                                    MINUS
                                    (
                                        SELECT
                                            cc.*
                                        FROM
                                            clienti_cinema    cc,
                                            produse_cumparate pc
                                        WHERE
                                            pc.id_client = cc.id
                                    )
                                ) cl_f_p
                        )
                        UNION
                        (
                            SELECT
                                nr_cl_p.id,
                                nr_cl_p.nr_produse
                            FROM
                                (
                                    SELECT
                                        cl_p.id,
                                        COUNT(cl_p.id) "NR_PRODUSE"
                                    FROM
                                        (
                                            SELECT
                                                cc.*
                                            FROM
                                                clienti_cinema    cc,
                                                produse_cumparate pc
                                            WHERE
                                                pc.id_client = cc.id
                                        ) cl_p
                                    GROUP BY
                                        cl_p.id
                                ) nr_cl_p
                            WHERE
                                nr_cl_p."NR_PRODUSE" >= 2
                        )
                    )              cl,
                    recenzii_filme rf
                WHERE
                    cl.id = rf.id_client
                GROUP BY
                    rf.id_client
            ) rf2
    )           ex14,
    cinema_user cu;

--15.
SELECT DISTINCT
    ex15.*,
    cu.username
FROM
    (
        SELECT
            top5."ID_FILM",
            a.nume
        FROM
            (
                SELECT
                    f.id        "ID_FILM",
                    COUNT(f.id) "NR_CLIENTI_FILM"
                FROM
                    clienti_cinema cc,
                    filme          f,
                    derulari_filme df
                WHERE
                        f.id = df.id_film
                    AND df.id = cc.id_derulare_film
                GROUP BY
                    f.id
                ORDER BY
                    "NR_CLIENTI_FILM"
                FETCH FIRST 5 ROWS ONLY
            )                 top5,
            distributie_filme distrf,
            actori            a,
            produse_cumparate pc
        WHERE
                top5."ID_FILM" = distrf.id_film
            AND distrf.id_actor = a.id
    )           ex15,
    cinema_user cu;

--16.
SELECT
    ex16.*,
    cu.username
FROM
    (
        (
            SELECT
                prod_filme."ID FILM"        "ID",
                COUNT(prod_filme."ID FILM") "NR_PRODUSE_CUMPARATE"
            FROM
                prod_filme
            GROUP BY
                prod_filme."ID FILM"
        )
        UNION ALL
        (
            SELECT
                cc.id        "ID",
                COUNT(cc.id) "NR_PRODUSE_CUMPARATE"
            FROM
                produse_cumparate pc,
                produse_cinema    pcin,
                clienti_cinema    cc
            WHERE
                    pc.id_produs = pcin.id
                AND cc.id = pc.id_client
            GROUP BY
                cc.id
        )
    )           ex16,
    cinema_user cu;

--17.
SELECT
    ex17.*,
    cu.username
FROM
    (
        SELECT
            f.id,
            f.nume,
            f.rating,
            nr_bil."NR BILETE VANDUTE"
        FROM
            filme f,
            (
                SELECT
                    df.id_film,
                    COUNT(df.id_film) "NR BILETE VANDUTE"
                FROM
                    clienti_cinema cc,
                    derulari_filme df,
                    filme          f
                WHERE
                        cc.id_derulare_film = df.id
                    AND f.id = df.id_film
                GROUP BY
                    df.id_film
            )     nr_bil
        WHERE
            nr_bil."ID_FILM" = f.id
    )           ex17,
    cinema_user cu;

--18.
SELECT
    ex18.*,
    cu.username
FROM
    (
        SELECT
            prod_filme.*,
            f.gen
        FROM
            prod_filme,
            filme f
        WHERE
            prod_filme."ID FILM" = f.id
    )           ex18,
    cinema_user cu;

--19.
SELECT
    ex19.*,
    cu.username
FROM
    (
        SELECT
            nume,
            cantitate_ceruta - "CANTITATE_CUMPARATA" "CANTITATE_RAMASA"
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            tip_produs,
                            cantitate_ceruta,
                            nume
                        FROM
                            stoc_lunar_cinema slc,
                            produse_cinema    pc
                        WHERE
                            slc.tip_produs = pc.id
                    ) t1,
                    (
                        SELECT
                            id_produs,
                            COUNT(id_produs) "CANTITATE_CUMPARATA"
                        FROM
                            produse_cumparate
                        GROUP BY
                            id_produs
                    ) t2
                WHERE
                    t1.tip_produs = t2.id_produs
            )
    )           ex19,
    cinema_user cu;

--20.
SELECT
    ex20.*,
    cu.username
FROM
    (
        SELECT
            a.*
        FROM
            actori            a,
            distributie_filme df,
            (
                SELECT
                    f.id,
                    COUNT(f.id) "NR_BILETE_CUMPARATE"
                FROM
                    derulari_filme df,
                    clienti_cinema cc,
                    filme          f
                WHERE
                        df.id = cc.id_derulare_film
                    AND f.id = df.id_film
                GROUP BY
                    f.id
            )                 filme_cumparate
        WHERE
                a.id = df.id_actor
            AND filme_cumparate.id = df.id_film
            AND filme_cumparate."NR_BILETE_CUMPARATE" >= 2
    )           ex20,
    cinema_user cu;