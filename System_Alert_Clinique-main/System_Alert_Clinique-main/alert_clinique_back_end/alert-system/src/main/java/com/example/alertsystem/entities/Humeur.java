package com.example.alertsystem.entities;
import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
public class Humeur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String etat; // Ex : "heureux", "fatigué"

    private OffsetDateTime timestamp = OffsetDateTime.now();

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEtat() { return etat; }
    public void setEtat(String etat) { this.etat = etat; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
}
