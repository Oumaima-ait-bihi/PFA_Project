package com.example.alertsystem.entities;


import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
public class HistoriqueAlerte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private OffsetDateTime dateAlerte = OffsetDateTime.now();
    private String description;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "alerte_id")
    private Alerte alerte;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public OffsetDateTime getDateAlerte() { return dateAlerte; }
    public void setDateAlerte(OffsetDateTime dateAlerte) { this.dateAlerte = dateAlerte; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Alerte getAlerte() { return alerte; }
    public void setAlerte(Alerte alerte) { this.alerte = alerte; }
}
