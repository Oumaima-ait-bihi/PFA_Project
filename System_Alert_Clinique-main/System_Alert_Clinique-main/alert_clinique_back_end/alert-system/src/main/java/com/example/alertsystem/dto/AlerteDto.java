package com.example.alertsystem.dto;

import com.example.alertsystem.entities.Alerte;
import java.time.OffsetDateTime;

public class AlerteDto {
    private Long id;
    private String type;
    private String message;
    private OffsetDateTime timestamp;
    private Long patientId;
    private String patientName;
    private Long medecinId;

    // Constructeurs
    public AlerteDto() {}

    public AlerteDto(Long id, String type, String message, OffsetDateTime timestamp, 
                    Long patientId, String patientName, Long medecinId) {
        this.id = id;
        this.type = type;
        this.message = message;
        this.timestamp = timestamp;
        this.patientId = patientId;
        this.patientName = patientName;
        this.medecinId = medecinId;
    }

    // Méthode statique pour convertir depuis l'entité Alerte
    public static AlerteDto fromEntity(Alerte alerte) {
        String patientName = "Patient inconnu";
        Long patientId = null;
        
        if (alerte.getPatient() != null) {
            patientName = alerte.getPatient().getName();
            patientId = alerte.getPatient().getId();
        }
        
        return new AlerteDto(
            alerte.getId(),
            alerte.getType(),
            alerte.getMessage(),
            alerte.getTimestamp(),
            patientId,
            patientName,
            alerte.getMedecin() != null ? alerte.getMedecin().getId() : null
        );
    }

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }

    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public Long getMedecinId() { return medecinId; }
    public void setMedecinId(Long medecinId) { this.medecinId = medecinId; }
}

