package com.example.alertsystem.service;

import com.example.alertsystem.dto.AIPredictionRequest;
import com.example.alertsystem.dto.AIPredictionResponse;
import com.example.alertsystem.dto.AISimplePredictionRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;

import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.Map;
import java.util.Map;

@Service
public class AIService {
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    private final PatientService patientService;
    
    @Value("${ai.service.url:http://localhost:5000}")
    private String aiServiceUrl;

    public AIService(PatientService patientService) {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
        this.patientService = patientService;
    }

    /**
     * Vérifie si le service IA est disponible
     */
    public boolean checkHealth() {
        try {
            String url = aiServiceUrl + "/health";
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            return response.getStatusCode().is2xxSuccessful();
        } catch (RestClientException e) {
            return false;
        }
    }

    /**
     * Fait une prédiction avec toutes les données requises
     */
    public AIPredictionResponse predict(AIPredictionRequest request) {
        try {
            String url = aiServiceUrl + "/predict";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            HttpEntity<AIPredictionRequest> entity = new HttpEntity<>(request, headers);
            
            // Récupérer la réponse comme String pour pouvoir la parser manuellement
            ResponseEntity<String> stringResponse = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                String.class
            );
            
            if (stringResponse.getStatusCode().is2xxSuccessful() && stringResponse.getBody() != null) {
                // Parser la réponse JSON manuellement
                @SuppressWarnings("unchecked")
                Map<String, Object> responseMap = (Map<String, Object>) objectMapper.readValue(
                    stringResponse.getBody(), 
                    Map.class
                );
                
                AIPredictionResponse response = new AIPredictionResponse();
                
                // Vérifier si c'est une réponse d'erreur
                if (responseMap.containsKey("error")) {
                    response.setSuccess(false);
                    response.setError((String) responseMap.get("error"));
                    return response;
                }
                
                // Extraire les données de prédiction
                if (responseMap.containsKey("prediction")) {
                    Map<String, Object> predictionMap = (Map<String, Object>) responseMap.get("prediction");
                    AIPredictionResponse.PredictionData predictionData = new AIPredictionResponse.PredictionData();
                    
                    if (predictionMap.containsKey("alert_flag")) {
                        predictionData.setAlert_flag((Boolean) predictionMap.get("alert_flag"));
                    }
                    if (predictionMap.containsKey("anomaly_score")) {
                        Object scoreObj = predictionMap.get("anomaly_score");
                        if (scoreObj instanceof Number) {
                            predictionData.setAnomaly_score(((Number) scoreObj).doubleValue());
                        }
                    }
                    if (predictionMap.containsKey("threshold_used")) {
                        Object thresholdObj = predictionMap.get("threshold_used");
                        if (thresholdObj instanceof Number) {
                            predictionData.setThreshold_used(((Number) thresholdObj).doubleValue());
                        }
                    }
                    if (predictionMap.containsKey("confidence")) {
                        Object confidenceObj = predictionMap.get("confidence");
                        if (confidenceObj instanceof Number) {
                            predictionData.setConfidence(((Number) confidenceObj).doubleValue());
                        }
                    }
                    
                    response.setSuccess(true);
                    response.setPrediction(predictionData);
                } else {
                    // Format alternatif: données directement dans la réponse
                    AIPredictionResponse.PredictionData predictionData = new AIPredictionResponse.PredictionData();
                    
                    if (responseMap.containsKey("alert_flag")) {
                        predictionData.setAlert_flag((Boolean) responseMap.get("alert_flag"));
                    }
                    if (responseMap.containsKey("anomaly_score")) {
                        Object scoreObj = responseMap.get("anomaly_score");
                        if (scoreObj instanceof Number) {
                            predictionData.setAnomaly_score(((Number) scoreObj).doubleValue());
                        }
                    }
                    
                    response.setSuccess(true);
                    response.setPrediction(predictionData);
                }
                
                return response;
            } else {
                AIPredictionResponse errorResponse = new AIPredictionResponse();
                errorResponse.setSuccess(false);
                errorResponse.setError("Erreur lors de la prédiction: Status " + stringResponse.getStatusCode());
                return errorResponse;
            }
        } catch (org.springframework.web.client.HttpClientErrorException e) {
            // Erreur 4xx (Bad Request, etc.)
            AIPredictionResponse errorResponse = new AIPredictionResponse();
            errorResponse.setSuccess(false);
            errorResponse.setError("Erreur du service IA (HTTP " + e.getStatusCode() + "): " + e.getResponseBodyAsString());
            return errorResponse;
        } catch (org.springframework.web.client.HttpServerErrorException e) {
            // Erreur 5xx (Internal Server Error, etc.)
            AIPredictionResponse errorResponse = new AIPredictionResponse();
            errorResponse.setSuccess(false);
            errorResponse.setError("Erreur serveur IA (HTTP " + e.getStatusCode() + "): " + e.getResponseBodyAsString());
            return errorResponse;
        } catch (RestClientException e) {
            // Erreur de connexion
            AIPredictionResponse errorResponse = new AIPredictionResponse();
            errorResponse.setSuccess(false);
            errorResponse.setError("Impossible de se connecter au service IA (" + aiServiceUrl + "): " + e.getMessage());
            return errorResponse;
        } catch (Exception e) {
            // Autres erreurs
            AIPredictionResponse errorResponse = new AIPredictionResponse();
            errorResponse.setSuccess(false);
            errorResponse.setError("Erreur lors de la prédiction IA: " + e.getMessage());
            return errorResponse;
        }
    }

    /**
     * Fait une prédiction simplifiée avec des valeurs par défaut pour les champs manquants
     */
    public AIPredictionResponse predictSimple(AISimplePredictionRequest simpleRequest) {
        try {
            // Récupérer l'âge et le genre du patient depuis la base de données si non fourni
            Integer age = simpleRequest.getAge();
            String gender = simpleRequest.getGender();
            
            // Essayer de récupérer les informations du patient depuis la base de données
            if ((age == null || gender == null) && simpleRequest.getPatientId() != null) {
                var patientOpt = patientService.getPatientById(simpleRequest.getPatientId().longValue());
                if (patientOpt.isPresent()) {
                    var patient = patientOpt.get();
                    if (age == null && patient.getAge() != null) {
                        age = patient.getAge();
                    }
                    if (gender == null && patient.getGender() != null) {
                        gender = patient.getGender();
                    }
                }
            }
            
            // Valeurs par défaut si toujours null
            if (age == null) {
                age = 45; // Valeur par défaut
            }
            if (gender == null) {
                gender = "M"; // Valeur par défaut
            }
            
            final Integer finalAge = age;
            final String finalGender = gender;
            
            // Convertir la requête simple en requête complète
            AIPredictionRequest fullRequest = new AIPredictionRequest();
            fullRequest.setPatient_id(simpleRequest.getPatientId());
            fullRequest.setHeart_rate(simpleRequest.getHeartRate());
            fullRequest.setHr_variability(simpleRequest.getHrVariability() != null ? 
                simpleRequest.getHrVariability() : 50.0);
            fullRequest.setSteps(simpleRequest.getSteps() != null ? 
                simpleRequest.getSteps() : 5000);
            fullRequest.setMood_score(simpleRequest.getMoodScore() != null ? 
                simpleRequest.getMoodScore() : 5.0);
            fullRequest.setSleep_duration_hours(simpleRequest.getSleepDurationHours());
            fullRequest.setSleep_efficiency(simpleRequest.getSleepEfficiency() != null ? 
                simpleRequest.getSleepEfficiency() : 85.0);
            fullRequest.setNum_awakenings(simpleRequest.getNumAwakenings() != null ? 
                simpleRequest.getNumAwakenings() : 1);
            fullRequest.setAge(finalAge);
            
            // Calculer day_of_week et weekend à partir de la date actuelle
            LocalDate today = LocalDate.now();
            DayOfWeek dayOfWeek = today.getDayOfWeek();
            fullRequest.setDay_of_week(dayOfWeek.getValue() - 1); // 0 = lundi
            fullRequest.setWeekend(dayOfWeek == DayOfWeek.SATURDAY || dayOfWeek == DayOfWeek.SUNDAY);
            
            fullRequest.setMedication_taken(simpleRequest.getMedicationTaken() != null ? 
                simpleRequest.getMedicationTaken() : false);
            fullRequest.setIs_female("F".equalsIgnoreCase(finalGender));
            fullRequest.setDate(today.toString());
            
            return predict(fullRequest);
        } catch (Exception e) {
            AIPredictionResponse errorResponse = new AIPredictionResponse();
            errorResponse.setSuccess(false);
            errorResponse.setError("Erreur lors de la prédiction simplifiée: " + e.getMessage());
            return errorResponse;
        }
    }
}

