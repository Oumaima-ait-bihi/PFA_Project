package com.example.alertsystem.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class AIPredictionRequest {
    private Long patient_id;
    private Double heart_rate;
    private Double hr_variability;
    private Integer steps;
    private Double mood_score;
    private Double sleep_duration_hours;
    private Double sleep_efficiency;
    private Integer num_awakenings;
    private Integer age;
    private Integer day_of_week; // 0-6 (0 = lundi, 6 = dimanche)
    private Boolean weekend;
    private Boolean medication_taken;
    private Boolean is_female;
    private String date; // Format: "YYYY-MM-DD"
}

