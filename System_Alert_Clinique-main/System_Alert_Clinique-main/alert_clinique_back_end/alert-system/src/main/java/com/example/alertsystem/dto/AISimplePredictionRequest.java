package com.example.alertsystem.dto;

import lombok.Data;

@Data
public class AISimplePredictionRequest {
    private Long patientId;
    private Integer age;
    private String gender; // 'M' ou 'F'
    private Double heartRate;
    private Double hrVariability;
    private Integer steps;
    private Double moodScore;
    private Double sleepDurationHours;
    private Double sleepEfficiency;
    private Integer numAwakenings;
    private Boolean medicationTaken;
}

