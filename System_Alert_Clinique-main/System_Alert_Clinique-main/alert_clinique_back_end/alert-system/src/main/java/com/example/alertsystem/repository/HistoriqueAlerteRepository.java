package com.example.alertsystem.repository;

import com.example.alertsystem.entities.HistoriqueAlerte;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HistoriqueAlerteRepository extends JpaRepository<HistoriqueAlerte, Long> {
}

