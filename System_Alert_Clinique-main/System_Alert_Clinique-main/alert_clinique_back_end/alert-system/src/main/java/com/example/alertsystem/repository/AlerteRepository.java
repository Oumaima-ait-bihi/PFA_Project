package com.example.alertsystem.repository;


import com.example.alertsystem.entities.Alerte;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface AlerteRepository extends JpaRepository<Alerte, Long> {
    @Query("SELECT a FROM Alerte a LEFT JOIN FETCH a.patient LEFT JOIN FETCH a.medecin")
    List<Alerte> findAllWithPatient();
}
