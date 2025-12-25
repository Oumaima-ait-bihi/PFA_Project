package com.example.alertsystem.entities;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;

@Entity
@DiscriminatorValue("Medecin")
public class MedecinUser extends User {
    public MedecinUser() {
        super();
    }

    public MedecinUser(String username, String password) {
        super(username, password, "Medecin");
    }
}

