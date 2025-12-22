package com.example.alertsystem.repository;


import com.example.alertsystem.entities.Alerte;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlerteRepository extends JpaRepository<Alerte, Long> {
}
