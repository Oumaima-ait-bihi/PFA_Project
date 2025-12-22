package com.example.alertsystem.dto;

import lombok.Data;

@Data
public class AIPredictionResponse {
    private Boolean success;
    private PredictionData prediction;
    private String error;

    @Data
    public static class PredictionData {
        private Boolean alert_flag;
        private Double anomaly_score;
        private Double threshold_used;
        private Double confidence;
    }
}


