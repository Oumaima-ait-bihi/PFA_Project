package com.example.alertsystem.entities;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.List;

@Entity
public class Alerte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String type;
    private String message;
    private OffsetDateTime timestamp = OffsetDateTime.now();

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "medecin_id")
    private Medecin medecin;

    @OneToMany(mappedBy = "alerte")
    private List<HistoriqueAlerte> historiqueAlertes;

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public OffsetDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(OffsetDateTime timestamp) { this.timestamp = timestamp; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Medecin getMedecin() { return medecin; }
    public void setMedecin(Medecin medecin) { this.medecin = medecin; }

    public List<HistoriqueAlerte> getHistoriqueAlertes() { return historiqueAlertes; }
    public void setHistoriqueAlertes(List<HistoriqueAlerte> historiqueAlertes) { this.historiqueAlertes = historiqueAlertes; }
}
