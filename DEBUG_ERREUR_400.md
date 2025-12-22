# Débogage Erreur 400 - Prédictions IA

## Problème
Les requêtes POST vers `/predict` retournent une erreur 400 (Bad Request), ce qui signifie que les données envoyées ne sont pas complètes ou mal formatées.

## Solution Immédiate

### 1. Vérifier les Logs du Service Python

Quand vous modifiez les données dans l'application mobile, regardez le **terminal du service Python**. Vous devriez maintenant voir :

```
[DEBUG] Données reçues: {
  "patient_id": 1,
  "heart_rate": 72.0,
  ...
}
[ERREUR] Champs manquants ou null: ['champ1', 'champ2', ...]
```

Cela vous indiquera **exactement quels champs manquent**.

### 2. Vérifier que le Backend est Démarré

Le backend Spring Boot doit être démarré pour que les requêtes passent :
```bash
cd System_Alert_Clinique-main\System_Alert_Clinique-main\alert_clinique_back_end\alert-system
mvn spring-boot:run
```

### 3. Vérifier les Logs du Backend

Dans le terminal du backend Spring Boot, vous devriez voir les requêtes reçues. Si vous voyez des erreurs, elles indiqueront le problème.

---

## Correction Appliquée

J'ai corrigé le code pour :
1. ✅ Ajouter des logs de débogage dans le service Python
2. ✅ Vérifier que `sleepDurationHours` n'est pas null dans le backend Java
3. ✅ Améliorer la gestion des erreurs dans le backend

---

## Prochaines Étapes

1. **Redémarrez le backend Spring Boot** (si ce n'est pas déjà fait)
2. **Modifiez les données** dans l'application mobile (humeur, sommeil, rythme cardiaque)
3. **Regardez les logs du service Python** pour voir les données reçues et les erreurs
4. **Partagez les logs** si le problème persiste

---

## Test Manuel

Vous pouvez aussi tester manuellement avec curl ou Postman :

```bash
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "patient_id": 1,
    "heart_rate": 72.0,
    "hr_variability": 50.0,
    "steps": 5000,
    "mood_score": 5.0,
    "sleep_duration_hours": 7.0,
    "sleep_efficiency": 85.0,
    "num_awakenings": 1,
    "age": 45,
    "day_of_week": 2,
    "weekend": false,
    "medication_taken": false,
    "is_female": false,
    "date": "2025-12-21"
  }'
```

Cela vous permettra de voir si le service Python fonctionne correctement avec des données complètes.

