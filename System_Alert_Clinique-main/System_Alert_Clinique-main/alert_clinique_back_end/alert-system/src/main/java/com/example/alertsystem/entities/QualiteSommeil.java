package com.example.alertsystem.entities;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
public class QualiteSommeil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private int duree;

    private OffsetDateTime timestamp = OffsetDateTime.now();

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public int getDuree() { return duree; }
    public void setDuree(int duree) { this.duree = duree; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
}
