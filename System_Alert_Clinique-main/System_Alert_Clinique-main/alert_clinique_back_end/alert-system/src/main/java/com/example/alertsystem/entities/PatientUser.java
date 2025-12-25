package com.example.alertsystem.entities;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("Patient")
public class PatientUser extends User {
    public PatientUser() {
        super();
    }

    public PatientUser(String username, String password) {
        super(username, password, "Patient");
    }
}

