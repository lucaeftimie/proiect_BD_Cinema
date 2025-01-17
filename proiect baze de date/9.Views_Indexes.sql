--Views
DROP VIEW cinema_user;
DROP VIEW prod_filme;

CREATE VIEW cinema_user AS
    (
        SELECT
            *
        FROM
            all_users
        WHERE
            username = upper('eftimiel_46')
    );

CREATE VIEW prod_filme AS
    (
        SELECT
            f.id      "ID FILM",
            pcin.nume "NUME PRODUS"
        FROM
            produse_cumparate pc,
            produse_cinema    pcin,
            clienti_cinema    cc,
            derulari_filme    df,
            filme             f
        WHERE
                pc.id_client = cc.id
            AND cc.id_derulare_film = df.id
            AND df.id_film = f.id
            AND pcin.id = pc.id_produs
);

--Indexes
DROP INDEX pc_id_client_index;
CREATE INDEX pc_id_client_index on produse_cumparate(id_client);




