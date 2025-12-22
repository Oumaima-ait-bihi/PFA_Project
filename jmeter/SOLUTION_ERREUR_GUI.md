# Solution pour l'erreur "Problem updating GUI" dans JMeter

## Problème
L'erreur "Problem updating GUI" dans JMeter 5.6.3 est souvent causée par des composants `JSONPostProcessor` incompatibles.

## Solutions

### Solution 1 : Recharger le fichier (Recommandé)

1. **Fermer JMeter complètement**
2. **Rouvrir JMeter**
3. **Ouvrir le fichier** : File → Open → `plan_test_alert_clinique.jmx`

Le fichier a été corrigé pour utiliser des composants plus compatibles.

### Solution 2 : Ignorer l'erreur et continuer

Si l'erreur apparaît mais que le plan de test se charge quand même :
1. Cliquer sur **OK** dans la boîte de dialogue d'erreur
2. Vérifier que le plan de test est visible dans l'arborescence
3. Si oui, vous pouvez lancer les tests normalement

### Solution 3 : Créer un nouveau plan simplifié

Si les erreurs persistent, créez un nouveau plan de test simple :

1. Dans JMeter : **File** → **New**
2. **Ajouter** → **Threads (Users)** → **Thread Group**
3. **Ajouter** → **Sampler** → **HTTP Request**
4. Configurer :
   - Server Name: `localhost`
   - Port: `8080`
   - Path: `/api/patients`
   - Method: `GET`
5. **Ajouter** → **Listener** → **View Results Tree**
6. Lancer le test

### Solution 4 : Vérifier les logs JMeter

Consulter le fichier de log JMeter pour plus de détails :
- Windows : `%USERPROFILE%\jmeter.log`
- Linux/Mac : `~/.jmeter/jmeter.log`

## Alternative : Utiliser le mode non-GUI

Si les problèmes GUI persistent, utilisez le mode ligne de commande :

```bash
cd jmeter
jmeter.bat -n -t plan_test_alert_clinique.jmx -l results/results.jtl -e -o results/html-report
```

Le mode non-GUI évite les problèmes d'interface graphique.

## Vérification

Après correction, le plan de test devrait :
- ✅ Se charger sans erreur
- ✅ Afficher tous les éléments dans l'arborescence
- ✅ Permettre de lancer les tests

Si le problème persiste, essayez de redémarrer JMeter ou utilisez le mode non-GUI.

