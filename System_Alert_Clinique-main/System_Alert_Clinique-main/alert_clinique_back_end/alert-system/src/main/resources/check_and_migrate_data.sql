-- ============================================
-- Script pour vérifier et migrer les données existantes
-- ============================================

-- 1. Vérifier la structure actuelle de la table patient
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'patient' AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Voir les données existantes (si la table existe)
SELECT * FROM patient LIMIT 10;

-- ============================================
-- OPTION A : Si ta table a des colonnes différentes (ex: "nom" au lieu de "name")
-- ============================================
-- Tu peux adapter les données existantes avec ce script :

-- Exemple : Si tu as une colonne "nom" et que tu veux la renommer en "name"
-- ALTER TABLE patient RENAME COLUMN nom TO name;

-- Exemple : Si tu as des colonnes manquantes, tu peux les ajouter :
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS email VARCHAR(255);
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS phone VARCHAR(255);
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS condition VARCHAR(500);
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'stable';
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS last_visit DATE;
-- ALTER TABLE patient ADD COLUMN IF NOT EXISTS assigned_doctor VARCHAR(255);

-- ============================================
-- OPTION B : Insérer des données de test pour vérifier que tout fonctionne
-- ============================================

-- Insérer des médecins de test
INSERT INTO medecin (nom, specialite, email, phone) VALUES
('Dr. Hasna Ait Ben Brahim', 'Cardiologie', 'hasna@hopital.com', '+33 6 11 22 33 44'),
('Dr. Jean Martin', 'Médecine générale', 'jean.martin@hopital.com', '+33 6 22 33 44 55'),
('Dr. Marie Dubois', 'Neurologie', 'marie.dubois@hopital.com', '+33 6 33 44 55 66')
ON CONFLICT (email) DO NOTHING;

-- Insérer des patients de test
INSERT INTO patient (name, email, phone, age, gender, "condition", status, last_visit, assigned_doctor, adresse) VALUES
('Sophie Martin', 'sophie.martin@email.com', '+33 6 12 34 56 78', 45, 'F', 'Hypertension sévère', 'critical', '2024-11-10', 'Dr. Hasna Ait Ben Brahim', '123 Rue de la Santé, 75013 Paris'),
('Ahmed Benali', 'ahmed.benali@email.com', '+33 6 23 45 67 89', 62, 'M', 'Insuffisance cardiaque', 'high', '2024-11-08', 'Dr. Jean Martin', '456 Avenue de la Santé, 75014 Paris'),
('Jean Lefebvre', 'jean.lefebvre@email.com', '+33 6 34 56 78 90', 55, 'M', 'Diabète type 2', 'stable', '2024-11-09', 'Dr. Hasna Ait Ben Brahim', '789 Boulevard de la Santé, 75015 Paris'),
('Fatima Alaoui', 'fatima.alaoui@email.com', '+33 6 45 67 89 01', 38, 'F', 'Arythmie cardiaque', 'high', '2024-11-07', 'Dr. Marie Dubois', '321 Rue de la Médecine, 75016 Paris'),
('Pierre Durand', 'pierre.durand@email.com', '+33 6 56 78 90 12', 71, 'M', 'Hypertension', 'stable', '2024-11-06', 'Dr. Jean Martin', '654 Avenue de la Santé, 75017 Paris')
ON CONFLICT (email) DO NOTHING;

-- Vérifier que les données sont bien insérées
SELECT COUNT(*) as total_patients FROM patient;
SELECT COUNT(*) as total_medecins FROM medecin;

-- Afficher les patients insérés
SELECT id, name, email, phone, age, gender, condition, status, last_visit, assigned_doctor 
FROM patient 
ORDER BY id;

