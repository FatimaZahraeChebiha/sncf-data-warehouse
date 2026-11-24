-- =============================================================
--  SNCF Data Warehouse - creation of sncf_oltp and sncf_dw
--  Run in MySQL: SOURCE 01_create_databases.sql
-- =============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

-- =============================================================
--  DROP EVERYTHING
-- =============================================================

DROP DATABASE IF EXISTS sncf_oltp;
DROP DATABASE IF EXISTS sncf_dw;

-- =============================================================
--  PART 1 : sncf_oltp
-- =============================================================

CREATE DATABASE sncf_oltp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sncf_oltp;

-- CLIENT
-- CSV: id_client,nom,prenom,date_naissance,sexe,type_client,ville,
--      code_postal,pays,email,telephone,date_creation_compte,
--      date_derniere_modification,statut_compte
CREATE TABLE CLIENT (
    id_client                  INT          NOT NULL,
    nom                        VARCHAR(100),
    prenom                     VARCHAR(100),
    date_naissance             DATE,
    sexe                       VARCHAR(10),
    type_client                VARCHAR(50),
    ville                      VARCHAR(100),
    code_postal                VARCHAR(10),
    pays                       VARCHAR(100),
    email                      VARCHAR(150),
    telephone                  VARCHAR(20),
    date_creation_compte       DATETIME,
    date_derniere_modification DATETIME,
    statut_compte              VARCHAR(30),
    PRIMARY KEY (id_client)
);

-- GARE
-- CSV: id_gare,nom_gare,ville,region,pays,nb_quais,type_gare,
--      taille_gare,electrification,annee_mise_en_service,
--      latitude,longitude,annee_mise_service,categorie_strategique
CREATE TABLE GARE (
    id_gare               INT          NOT NULL,
    nom_gare              VARCHAR(150),
    ville                 VARCHAR(100),
    region                VARCHAR(100),
    pays                  VARCHAR(100),
    nb_quais              INT,
    type_gare             VARCHAR(50),
    taille_gare           VARCHAR(30),
    electrification       VARCHAR(30),
    annee_mise_en_service YEAR,
    latitude              DECIMAL(9,6),
    longitude             DECIMAL(9,6),
    annee_mise_service    YEAR,
    categorie_strategique VARCHAR(50),
    PRIMARY KEY (id_gare)
);

-- TRAIN
CREATE TABLE TRAIN (
    id_train             INT          NOT NULL,
    code_train           VARCHAR(50),
    type_train           VARCHAR(50),
    capacite_totale      INT,
    capacite_1           INT,
    capacite_2           INT,
    energie              VARCHAR(50),
    statut_train         VARCHAR(30),
    annee_mise_service   YEAR,
    PRIMARY KEY (id_train)
);

-- TRAJET
-- CSV: id_trajet,id_train,id_gare_depart,id_gare_arrivee,
--      date_depart,heure_depart,heure_arrivee_prevue,
--      distance_km,statut_circulation
CREATE TABLE TRAJET (
    id_trajet            INT          NOT NULL,
    id_train             INT          NOT NULL,
    id_gare_depart       INT          NOT NULL,
    id_gare_arrivee      INT          NOT NULL,
    date_depart          DATE,
    heure_depart         TIME,
    heure_arrivee_prevue TIME,
    distance_km          DECIMAL(8,2),
    statut_circulation   VARCHAR(30),
    PRIMARY KEY (id_trajet),
    FOREIGN KEY (id_train)        REFERENCES TRAIN(id_train),
    FOREIGN KEY (id_gare_depart)  REFERENCES GARE(id_gare),
    FOREIGN KEY (id_gare_arrivee) REFERENCES GARE(id_gare)
);

-- RESERVATION
-- CSV: id_reservation,id_client,id_trajet,date_reservation,
--      tarif_type,classe_reservee,prix_unitaire,nb_passagers,
--      montant_total,canal_vente,mode_paiement,statut_reservation
CREATE TABLE RESERVATION (
    id_reservation     INT            NOT NULL,
    id_client          INT            NOT NULL,
    id_trajet          INT            NOT NULL,
    date_reservation   DATETIME,
    tarif_type         VARCHAR(50),
    classe_reservee    VARCHAR(10),
    prix_unitaire      DECIMAL(10,2),
    nb_passagers       INT,
    montant_total      DECIMAL(10,2),
    canal_vente        VARCHAR(50),
    mode_paiement      VARCHAR(50),
    statut_reservation VARCHAR(30),
    PRIMARY KEY (id_reservation),
    FOREIGN KEY (id_client) REFERENCES CLIENT(id_client),
    FOREIGN KEY (id_trajet) REFERENCES TRAJET(id_trajet)
);

-- =============================================================
--  PART 2 : sncf_dw
-- =============================================================

CREATE DATABASE sncf_dw CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sncf_dw;

CREATE TABLE dim_date (
    sk_date      INT        NOT NULL AUTO_INCREMENT,
    id_date      DATE       NOT NULL,
    jour         TINYINT,
    mois         TINYINT,
    annee        SMALLINT,
    trimestre    TINYINT,
    semaine      TINYINT,
    jour_semaine VARCHAR(20),
    nom_mois     VARCHAR(20),
    est_weekend  TINYINT(1) DEFAULT 0,
    est_ferie    TINYINT(1) DEFAULT 0,
    saison       VARCHAR(20),
    PRIMARY KEY (sk_date),
    UNIQUE KEY uq_date (id_date)
);

CREATE TABLE dim_client (
    sk_client    INT          NOT NULL AUTO_INCREMENT,
    id_client    INT          NOT NULL,
    nom          VARCHAR(100),
    prenom       VARCHAR(100),
    sexe         VARCHAR(10),
    tranche_age  VARCHAR(30),
    type_client  VARCHAR(50),
    ville        VARCHAR(100),
    code_postal  VARCHAR(10),
    pays         VARCHAR(100),
    statut_compte VARCHAR(30),
    PRIMARY KEY (sk_client),
    KEY idx_id_client (id_client)
);

CREATE TABLE dim_train (
    sk_train           INT        NOT NULL AUTO_INCREMENT,
    id_train           INT        NOT NULL,
    code_train         VARCHAR(50),
    type_train         VARCHAR(50),
    capacite_totale    INT,
    capacite_1         INT,
    capacite_2         INT,
    energie            VARCHAR(50),
    statut_train       VARCHAR(30),
    annee_mise_service YEAR,
    PRIMARY KEY (sk_train),
    KEY idx_id_train (id_train)
);

CREATE TABLE dim_gare_dept (
    sk_gare               INT          NOT NULL AUTO_INCREMENT,
    id_gare               INT          NOT NULL,
    nom_gare              VARCHAR(150),
    ville                 VARCHAR(100),
    region                VARCHAR(100),
    pays                  VARCHAR(100),
    nb_quais              INT,
    type_gare             VARCHAR(50),
    taille_gare           VARCHAR(30),
    electrification       VARCHAR(30),
    categorie_strategique VARCHAR(50),
    latitude              DECIMAL(9,6),
    longitude             DECIMAL(9,6),
    PRIMARY KEY (sk_gare),
    KEY idx_id_gare_d (id_gare)
);

CREATE TABLE dim_gare_arr (
    sk_gare               INT          NOT NULL AUTO_INCREMENT,
    id_gare               INT          NOT NULL,
    nom_gare              VARCHAR(150),
    ville                 VARCHAR(100),
    region                VARCHAR(100),
    pays                  VARCHAR(100),
    nb_quais              INT,
    type_gare             VARCHAR(50),
    taille_gare           VARCHAR(30),
    electrification       VARCHAR(30),
    categorie_strategique VARCHAR(50),
    latitude              DECIMAL(9,6),
    longitude             DECIMAL(9,6),
    PRIMARY KEY (sk_gare),
    KEY idx_id_gare_a (id_gare)
);

CREATE TABLE dim_tarif (
    sk_tarif   INT         NOT NULL AUTO_INCREMENT,
    tarif_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (sk_tarif),
    UNIQUE KEY uq_tarif (tarif_type)
);

CREATE TABLE dim_canal_vente (
    sk_canal    INT         NOT NULL AUTO_INCREMENT,
    canal_vente VARCHAR(50) NOT NULL,
    PRIMARY KEY (sk_canal),
    UNIQUE KEY uq_canal (canal_vente)
);

CREATE TABLE dim_classe_reservation (
    sk_classe       INT         NOT NULL AUTO_INCREMENT,
    classe_reservee VARCHAR(10) NOT NULL,
    PRIMARY KEY (sk_classe),
    UNIQUE KEY uq_classe (classe_reservee)
);

CREATE TABLE dim_statut_reservation (
    sk_statut_res      INT         NOT NULL AUTO_INCREMENT,
    statut_reservation VARCHAR(30) NOT NULL,
    PRIMARY KEY (sk_statut_res),
    UNIQUE KEY uq_statut (statut_reservation)
);

CREATE TABLE dim_mode_paiement (
    sk_mode_pmt   INT         NOT NULL AUTO_INCREMENT,
    mode_paiement VARCHAR(50) NOT NULL,
    PRIMARY KEY (sk_mode_pmt),
    UNIQUE KEY uq_mode (mode_paiement)
);

CREATE TABLE f_ventes (
    sk_vente         BIGINT       NOT NULL AUTO_INCREMENT,
    sk_date          INT          NOT NULL,
    sk_client        INT          NOT NULL,
    sk_train         INT          NOT NULL,
    sk_gare_dept     INT          NOT NULL,
    sk_gare_arr      INT          NOT NULL,
    sk_tarif         INT          NOT NULL,
    sk_canal         INT          NOT NULL,
    sk_classe        INT          NOT NULL,
    sk_statut_res    INT          NOT NULL,
    sk_mode_pmt      INT          NOT NULL,
    id_reservation   INT          NOT NULL,
    montant_total    DECIMAL(12,2),
    nb_passagers     INT          DEFAULT 1,
    distance_km      DECIMAL(8,2),
    duree_trajet_min INT,
    PRIMARY KEY (sk_vente),
    CONSTRAINT fk_fv_date    FOREIGN KEY (sk_date)       REFERENCES dim_date(sk_date),
    CONSTRAINT fk_fv_client  FOREIGN KEY (sk_client)     REFERENCES dim_client(sk_client),
    CONSTRAINT fk_fv_train   FOREIGN KEY (sk_train)      REFERENCES dim_train(sk_train),
    CONSTRAINT fk_fv_gare_d  FOREIGN KEY (sk_gare_dept)  REFERENCES dim_gare_dept(sk_gare),
    CONSTRAINT fk_fv_gare_a  FOREIGN KEY (sk_gare_arr)   REFERENCES dim_gare_arr(sk_gare),
    CONSTRAINT fk_fv_tarif   FOREIGN KEY (sk_tarif)      REFERENCES dim_tarif(sk_tarif),
    CONSTRAINT fk_fv_canal   FOREIGN KEY (sk_canal)      REFERENCES dim_canal_vente(sk_canal),
    CONSTRAINT fk_fv_classe  FOREIGN KEY (sk_classe)     REFERENCES dim_classe_reservation(sk_classe),
    CONSTRAINT fk_fv_statut  FOREIGN KEY (sk_statut_res) REFERENCES dim_statut_reservation(sk_statut_res),
    CONSTRAINT fk_fv_mode    FOREIGN KEY (sk_mode_pmt)   REFERENCES dim_mode_paiement(sk_mode_pmt),
    KEY idx_date    (sk_date),
    KEY idx_client  (sk_client),
    KEY idx_train   (sk_train),
    KEY idx_gare_d  (sk_gare_dept),
    KEY idx_gare_a  (sk_gare_arr)
);

-- =============================================================
--  PART 3 : GENERATE dim_date (2015 -> 2030)
-- =============================================================

USE sncf_dw;

DROP PROCEDURE IF EXISTS fill_dim_date;

DELIMITER $$
CREATE PROCEDURE fill_dim_date(p_start DATE, p_end DATE)
BEGIN
    DECLARE v_date DATE DEFAULT p_start;
    WHILE v_date <= p_end DO
        INSERT IGNORE INTO dim_date (
            id_date, jour, mois, annee, trimestre, semaine,
            jour_semaine, nom_mois, est_weekend, saison
        ) VALUES (
            v_date,
            DAY(v_date), MONTH(v_date), YEAR(v_date),
            QUARTER(v_date), WEEK(v_date, 3),
            ELT(WEEKDAY(v_date)+1,'Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'),
            ELT(MONTH(v_date),'Janvier','Février','Mars','Avril','Mai','Juin',
                'Juillet','Août','Septembre','Octobre','Novembre','Décembre'),
            IF(DAYOFWEEK(v_date) IN (1,7), 1, 0),
            CASE
                WHEN MONTH(v_date) IN (12,1,2) THEN 'Hiver'
                WHEN MONTH(v_date) IN (3,4,5)  THEN 'Printemps'
                WHEN MONTH(v_date) IN (6,7,8)  THEN 'Été'
                ELSE 'Automne'
            END
        );
        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

CALL fill_dim_date('2015-01-01', '2030-12-31');

-- =============================================================
--  PART 4 : LOAD CSV DATA INTO sncf_oltp
-- =============================================================

USE sncf_oltp;

-- CLIENT
LOAD DATA LOCAL INFILE 'C:/data/CLIENT_OLTP_SNCF_100K.csv'
INTO TABLE CLIENT
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_client, nom, prenom, date_naissance, sexe, type_client,
 ville, code_postal, pays, email, telephone,
 date_creation_compte, date_derniere_modification, statut_compte);

-- GARE
LOAD DATA LOCAL INFILE 'C:/data/GARE_OLTP_SNCF_198.csv'
INTO TABLE GARE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_gare, nom_gare, ville, region, pays, nb_quais, type_gare,
 taille_gare, electrification, annee_mise_en_service,
 latitude, longitude, annee_mise_service, categorie_strategique);

-- TRAIN
LOAD DATA LOCAL INFILE 'C:/data/TRAIN_OLTP_SNCF_2500.csv'
INTO TABLE TRAIN
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_train, code_train, type_train, capacite_totale,
 capacite_1, capacite_2, energie, statut_train, annee_mise_service);

-- TRAJET (5 years)
LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2021.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2022.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2023.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2024.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2025.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

-- RESERVATION (5 years - biggest files, loaded last)
LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2021_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2022_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2023_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2024_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2025_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
--  VERIFY ALL TABLES
-- =============================================================

SELECT 'sncf_oltp' AS db, 'CLIENT'      AS tbl, COUNT(*) AS rows FROM sncf_oltp.CLIENT
UNION ALL SELECT 'sncf_oltp', 'GARE',        COUNT(*) FROM sncf_oltp.GARE
UNION ALL SELECT 'sncf_oltp', 'TRAIN',       COUNT(*) FROM sncf_oltp.TRAIN
UNION ALL SELECT 'sncf_oltp', 'TRAJET',      COUNT(*) FROM sncf_oltp.TRAJET
UNION ALL SELECT 'sncf_oltp', 'RESERVATION', COUNT(*) FROM sncf_oltp.RESERVATION
UNION ALL SELECT 'sncf_dw',   'dim_date',    COUNT(*) FROM sncf_dw.dim_date
UNION ALL SELECT 'sncf_dw',   'dim_client',  COUNT(*) FROM sncf_dw.dim_client
UNION ALL SELECT 'sncf_dw',   'dim_train',   COUNT(*) FROM sncf_dw.dim_train
UNION ALL SELECT 'sncf_dw',   'f_ventes',    COUNT(*) FROM sncf_dw.f_ventes;