-- ============================================
-- Script SQL pour créer les tables PostgreSQL
-- Compatible avec les entités Java Spring Boot
-- ============================================

-- Supprimer les tables existantes (ATTENTION: supprime toutes les données)
DROP TABLE IF EXISTS historique_alerte CASCADE;
DROP TABLE IF EXISTS alerte CASCADE;
DROP TABLE IF EXISTS humeur CASCADE;
DROP TABLE IF EXISTS qualite_sommeil CASCADE;
DROP TABLE IF EXISTS rythme_cardiaque CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS medecin CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- Table: users (classe de base pour Admin)
-- ============================================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(31) NOT NULL CHECK (role IN ('Admin', 'Patient', 'Medecin'))
);

-- ============================================
-- Table: admin (hérite de User)
-- ============================================
CREATE TABLE admin (
    id BIGINT PRIMARY KEY,
    CONSTRAINT fk_admin_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Table: patient_user (hérite de User)
-- ============================================
CREATE TABLE patient_user (
    id BIGINT PRIMARY KEY,
    CONSTRAINT fk_patient_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Table: medecin_user (hérite de User)
-- ============================================
CREATE TABLE medecin_user (
    id BIGINT PRIMARY KEY,
    CONSTRAINT fk_medecin_user FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Table: medecin
-- ============================================
CREATE TABLE medecin (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    specialite VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL,
    password VARCHAR(255)
);

-- ============================================
-- Table: patient
-- ============================================
CREATE TABLE patient (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('M', 'F')),
    "condition" VARCHAR(500),
    status VARCHAR(20) NOT NULL CHECK (status IN ('critical', 'high', 'stable')),
    last_visit DATE,
    assigned_doctor VARCHAR(255),
    adresse VARCHAR(500),
    password VARCHAR(255)
);

-- ============================================
-- Table: rythme_cardiaque
-- ============================================
CREATE TABLE rythme_cardiaque (
    id BIGSERIAL PRIMARY KEY,
    valeur INTEGER NOT NULL,
    timestamp TIMESTAMP(6) WITH TIME ZONE,
    patient_id BIGINT,
    CONSTRAINT fk_rythme_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- ============================================
-- Table: qualite_sommeil
-- ============================================
CREATE TABLE qualite_sommeil (
    id BIGSERIAL PRIMARY KEY,
    duree INTEGER NOT NULL,
    timestamp TIMESTAMP(6) WITH TIME ZONE,
    patient_id BIGINT,
    CONSTRAINT fk_sommeil_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- ============================================
-- Table: humeur
-- ============================================
CREATE TABLE humeur (
    id BIGSERIAL PRIMARY KEY,
    etat VARCHAR(255),
    timestamp TIMESTAMP(6) WITH TIME ZONE,
    patient_id BIGINT,
    CONSTRAINT fk_humeur_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- ============================================
-- Table: alerte
-- ============================================
CREATE TABLE alerte (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(255),
    message VARCHAR(255),
    timestamp TIMESTAMP(6) WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    patient_id BIGINT,
    medecin_id BIGINT,
    CONSTRAINT fk_alerte_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,
    CONSTRAINT fk_alerte_medecin FOREIGN KEY (medecin_id) REFERENCES medecin(id) ON DELETE SET NULL
);

-- ============================================
-- Table: historique_alerte
-- ============================================
CREATE TABLE historique_alerte (
    id BIGSERIAL PRIMARY KEY,
    date_alerte TIMESTAMP(6) WITH TIME ZONE,
    description VARCHAR(255),
    alerte_id BIGINT,
    patient_id BIGINT,
    CONSTRAINT fk_historique_alerte FOREIGN KEY (alerte_id) REFERENCES alerte(id) ON DELETE CASCADE,
    CONSTRAINT fk_historique_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE
);

-- ============================================
-- Index pour améliorer les performances
-- ============================================
CREATE INDEX idx_patient_email ON patient(email);
CREATE INDEX idx_patient_status ON patient(status);
CREATE INDEX idx_medecin_email ON medecin(email);
CREATE INDEX idx_alerte_patient ON alerte(patient_id);
CREATE INDEX idx_alerte_medecin ON alerte(medecin_id);
CREATE INDEX idx_rythme_patient ON rythme_cardiaque(patient_id);
CREATE INDEX idx_sommeil_patient ON qualite_sommeil(patient_id);
CREATE INDEX idx_humeur_patient ON humeur(patient_id);

-- ============================================
-- Données de test (optionnel)
-- ============================================
-- INSERT INTO medecin (nom, specialite, email, phone) VALUES
-- ('Dr. Hasna Ait Ben Brahim', 'Cardiologie', 'hasna@hopital.com', '+33 6 11 22 33 44'),
-- ('Dr. Jean Martin', 'Médecine générale', 'jean.martin@hopital.com', '+33 6 22 33 44 55');

-- INSERT INTO patient (name, email, phone, age, gender, condition, status, last_visit, assigned_doctor, adresse) VALUES
-- ('Sophie Martin', 'sophie.martin@email.com', '+33 6 12 34 56 78', 45, 'F', 'Hypertension sévère', 'critical', '2024-11-10', 'Dr. Hasna Ait Ben Brahim', '123 Rue de la Santé, Paris'),
-- ('Ahmed Benali', 'ahmed.benali@email.com', '+33 6 23 45 67 89', 62, 'M', 'Insuffisance cardiaque', 'high', '2024-11-08', 'Dr. Jean Martin', '456 Avenue de la Santé, Paris');

