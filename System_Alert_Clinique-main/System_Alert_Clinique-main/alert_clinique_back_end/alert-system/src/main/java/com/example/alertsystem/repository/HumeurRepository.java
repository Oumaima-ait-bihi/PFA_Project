package com.example.alertsystem.repository;

import com.example.alertsystem.entities.Humeur;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HumeurRepository extends JpaRepository<Humeur, Long> {
}

