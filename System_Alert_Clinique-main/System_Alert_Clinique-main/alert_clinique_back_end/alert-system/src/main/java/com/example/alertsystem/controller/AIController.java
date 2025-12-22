package com.example.alertsystem.controller;

import com.example.alertsystem.dto.AIPredictionRequest;
import com.example.alertsystem.dto.AIPredictionResponse;
import com.example.alertsystem.dto.AISimplePredictionRequest;
import com.example.alertsystem.service.AIService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AIController {
    private final AIService aiService;

    public AIController(AIService aiService) {
        this.aiService = aiService;
    }

    /**
     * GET /api/ai/health - Vérifie la disponibilité du service IA
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> checkHealth() {
        boolean isHealthy = aiService.checkHealth();
        Map<String, Object> response = new HashMap<>();
        response.put("available", isHealthy);
        response.put("message", isHealthy ? "Service IA disponible" : "Service IA indisponible");
        return ResponseEntity.ok(response);
    }

    /**
     * POST /api/ai/predict - Prédiction avec données complètes
     */
    @PostMapping("/predict")
    public ResponseEntity<AIPredictionResponse> predict(@RequestBody AIPredictionRequest request) {
        AIPredictionResponse response = aiService.predict(request);
        if (response.getSuccess() != null && response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }

    /**
     * POST /api/ai/predict/simple - Prédiction simplifiée avec paramètres de base
     */
    @PostMapping("/predict/simple")
    public ResponseEntity<AIPredictionResponse> predictSimple(@RequestBody AISimplePredictionRequest request) {
        AIPredictionResponse response = aiService.predictSimple(request);
        if (response.getSuccess() != null && response.getSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
}

