-- =============================================================
--  SNCF - LOAD ALL CSV DATA  (line ending = \n)
--  Run in MySQL: SOURCE 02_load_csv_data.sql (CSV files in C:/data/)
-- =============================================================

SET FOREIGN_KEY_CHECKS = 0;

USE sncf_oltp;

-- Clean existing data first
TRUNCATE TABLE RESERVATION;
TRUNCATE TABLE TRAJET;
TRUNCATE TABLE CLIENT;
TRUNCATE TABLE TRAIN;
TRUNCATE TABLE GARE;

-- -----------------------------------------------------------
-- GARE (198 rows)
-- -----------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/data/GARE_OLTP_SNCF_198.csv'
INTO TABLE GARE
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_gare, nom_gare, ville, region, pays, nb_quais, type_gare,
 taille_gare, electrification, annee_mise_en_service,
 latitude, longitude, annee_mise_service, categorie_strategique);

SELECT 'GARE' AS tbl, COUNT(*) AS total FROM GARE;

-- -----------------------------------------------------------
-- CLIENT (100 000 rows)
-- -----------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/data/CLIENT_OLTP_SNCF_100K.csv'
INTO TABLE CLIENT
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_client, nom, prenom, date_naissance, sexe, type_client,
 ville, code_postal, pays, email, telephone,
 date_creation_compte, date_derniere_modification, statut_compte);

SELECT 'CLIENT' AS tbl, COUNT(*) AS total FROM CLIENT;

-- -----------------------------------------------------------
-- TRAIN (2500 rows)
-- -----------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/data/TRAIN_OLTP_SNCF_2500.csv'
INTO TABLE TRAIN
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_train, code_train, type_train, capacite_totale,
 capacite_1, capacite_2, energie, statut_train, annee_mise_service);

SELECT 'TRAIN' AS tbl, COUNT(*) AS total FROM TRAIN;

-- -----------------------------------------------------------
-- TRAJET 2021-2025
-- -----------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2021.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2022.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2023.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2024.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

LOAD DATA LOCAL INFILE 'C:/data/TRAJET_2025.csv'
INTO TABLE TRAJET
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_trajet, id_train, id_gare_depart, id_gare_arrivee,
 date_depart, heure_depart, heure_arrivee_prevue,
 distance_km, statut_circulation);

SELECT 'TRAJET' AS tbl, COUNT(*) AS total FROM TRAJET;

-- -----------------------------------------------------------
-- RESERVATION 2021-2025 (~2M rows each)
-- -----------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2021_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2022_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2023_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2024_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

LOAD DATA LOCAL INFILE 'C:/data/RESERVATION_2025_2M.csv'
INTO TABLE RESERVATION
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reservation, id_client, id_trajet, date_reservation,
 tarif_type, classe_reservee, prix_unitaire, nb_passagers,
 montant_total, canal_vente, mode_paiement, statut_reservation);

SELECT 'RESERVATION' AS tbl, COUNT(*) AS total FROM RESERVATION;

SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------
-- FINAL CHECK
-- -----------------------------------------------------------
SELECT 'GARE'        AS tbl, COUNT(*) AS total FROM sncf_oltp.GARE
UNION ALL SELECT 'CLIENT',      COUNT(*) FROM sncf_oltp.CLIENT
UNION ALL SELECT 'TRAIN',       COUNT(*) FROM sncf_oltp.TRAIN
UNION ALL SELECT 'TRAJET',      COUNT(*) FROM sncf_oltp.TRAJET
UNION ALL SELECT 'RESERVATION', COUNT(*) FROM sncf_oltp.RESERVATION;