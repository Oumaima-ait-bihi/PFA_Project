-- ============================================
-- Script de migration si tu as déjà des données avec l'ancienne structure
-- (ex: colonne "nom" au lieu de "name")
-- ============================================

-- ÉTAPE 1 : Sauvegarder les données existantes dans une table temporaire
CREATE TABLE IF NOT EXISTS patient_backup AS SELECT * FROM patient;

-- ÉTAPE 2 : Vérifier quelles colonnes existent
DO $$
DECLARE
    col_exists boolean;
BEGIN
    -- Vérifier si la colonne "nom" existe
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'patient' AND column_name = 'nom'
    ) INTO col_exists;
    
    IF col_exists THEN
        -- Si "nom" existe, créer "name" et copier les données
        ALTER TABLE patient ADD COLUMN IF NOT EXISTS name VARCHAR(255);
        UPDATE patient SET name = nom WHERE name IS NULL;
        
        -- Optionnel : supprimer l'ancienne colonne après vérification
        -- ALTER TABLE patient DROP COLUMN nom;
    END IF;
END $$;

-- ÉTAPE 3 : Ajouter les colonnes manquantes si elles n'existent pas
ALTER TABLE patient ADD COLUMN IF NOT EXISTS email VARCHAR(255);
ALTER TABLE patient ADD COLUMN IF NOT EXISTS phone VARCHAR(255);
ALTER TABLE patient ADD COLUMN IF NOT EXISTS gender VARCHAR(10);
ALTER TABLE patient ADD COLUMN IF NOT EXISTS "condition" VARCHAR(500);
ALTER TABLE patient ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'stable';
ALTER TABLE patient ADD COLUMN IF NOT EXISTS last_visit DATE;
ALTER TABLE patient ADD COLUMN IF NOT EXISTS assigned_doctor VARCHAR(255);

-- ÉTAPE 4 : Mettre à jour les données existantes avec des valeurs par défaut si nécessaire
UPDATE patient 
SET 
    email = COALESCE(email, 'patient' || id || '@example.com'),
    phone = COALESCE(phone, '+33 6 00 00 00 00'),
    gender = COALESCE(gender, 'M'),
    status = COALESCE(status, 'stable')
WHERE email IS NULL OR phone IS NULL OR gender IS NULL OR status IS NULL;

-- ÉTAPE 5 : Vérifier le résultat
SELECT id, name, email, phone, age, gender, "condition", status 
FROM patient 
ORDER BY id;

