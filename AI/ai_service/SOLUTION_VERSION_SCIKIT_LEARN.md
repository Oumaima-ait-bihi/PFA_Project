# Solution : Incompatibilité de Version scikit-learn

## Problème

Le modèle a été entraîné avec **scikit-learn 1.3.2**, mais l'environnement virtuel utilise **scikit-learn 1.8.0**. Cela cause l'erreur :

```
AttributeError: Can't get attribute '__pyx_unpickle_CyHalfBinomialLoss'
```

## Solution

### Option 1 : Utiliser le Script Automatique (Recommandé)

1. **Arrêter le service Flask** (Ctrl+C dans le terminal où il s'exécute)

2. **Exécuter le script de correction** :
   ```bash
   cd AI\ai_service
   FIX_SCIKIT_LEARN.bat
   ```

3. **Redémarrer le service IA** :
   ```bash
   start_ai_service.bat
   ```

### Option 2 : Correction Manuelle

1. **Arrêter le service Flask** (Ctrl+C)

2. **Activer l'environnement virtuel** :
   ```bash
   cd AI\ai_service
   venv_ai\Scripts\activate
   ```

3. **Désinstaller scikit-learn 1.8.0** :
   ```bash
   pip uninstall scikit-learn -y
   ```

4. **Installer scikit-learn 1.3.2** :
   ```bash
   pip install scikit-learn==1.3.2
   ```

5. **Vérifier l'installation** :
   ```bash
   pip show scikit-learn
   ```
   Devrait afficher : `Version: 1.3.2`

6. **Redémarrer le service IA** :
   ```bash
   python app.py
   ```

## Vérification

Après avoir installé scikit-learn 1.3.2, le service IA devrait démarrer sans erreur et afficher :

```
[OK] Modèle chargé avec succès!
[OK] Seuil chargé: 0.xxxx
[OK] Service IA prêt!
```

Et le endpoint `/health` devrait retourner :
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

## Note Importante

Si vous obtenez une erreur de permission lors de la désinstallation, c'est parce que le service Flask est encore en cours d'exécution. **Fermez d'abord le service Flask** (Ctrl+C) avant de réessayer.

## Prévention

Le fichier `requirements.txt` a été mis à jour pour spécifier `scikit-learn==1.3.2` au lieu de `scikit-learn>=1.4.0`. Cela garantit que la bonne version sera installée lors de futures installations.

