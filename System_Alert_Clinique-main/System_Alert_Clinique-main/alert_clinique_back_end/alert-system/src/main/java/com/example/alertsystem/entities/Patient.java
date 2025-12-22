package com.example.alertsystem.entities;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "patient")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private Integer age;

    @Column(nullable = false)
    private String gender; // 'M' ou 'F'

    @Column(name = "\"condition\"")
    private String condition; // Ex: "Hypertension sévère"

    @Column(nullable = false)
    private String status; // 'critical', 'high', 'stable'

    @Column(name = "last_visit")
    private LocalDate lastVisit;

    @Column(name = "assigned_doctor")
    private String assignedDoctor; // Nom du médecin assigné

    @Column
    private String adresse;

    @Column
    private String password;

    // Relations
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RythmeCardiaque> rythmeCardiaques;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<QualiteSommeil> qualiteSommeils;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Humeur> humeurs;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Alerte> alertes;

    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<HistoriqueAlerte> historiqueAlertes;

    // Constructeurs
    public Patient() {}

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getCondition() { return condition; }
    public void setCondition(String condition) { this.condition = condition; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDate getLastVisit() { return lastVisit; }
    public void setLastVisit(LocalDate lastVisit) { this.lastVisit = lastVisit; }

    public String getAssignedDoctor() { return assignedDoctor; }
    public void setAssignedDoctor(String assignedDoctor) { this.assignedDoctor = assignedDoctor; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    // Relations
    public List<RythmeCardiaque> getRythmeCardiaques() { return rythmeCardiaques; }
    public void setRythmeCardiaques(List<RythmeCardiaque> rythmeCardiaques) { this.rythmeCardiaques = rythmeCardiaques; }

    public List<QualiteSommeil> getQualiteSommeils() { return qualiteSommeils; }
    public void setQualiteSommeils(List<QualiteSommeil> qualiteSommeils) { this.qualiteSommeils = qualiteSommeils; }

    public List<Humeur> getHumeurs() { return humeurs; }
    public void setHumeurs(List<Humeur> humeurs) { this.humeurs = humeurs; }

    public List<Alerte> getAlertes() { return alertes; }
    public void setAlertes(List<Alerte> alertes) { this.alertes = alertes; }

    public List<HistoriqueAlerte> getHistoriqueAlertes() { return historiqueAlertes; }
    public void setHistoriqueAlertes(List<HistoriqueAlerte> historiqueAlertes) { this.historiqueAlertes = historiqueAlertes; }
}
