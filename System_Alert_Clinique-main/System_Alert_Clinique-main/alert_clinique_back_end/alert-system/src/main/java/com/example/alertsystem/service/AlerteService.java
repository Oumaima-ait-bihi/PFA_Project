package com.example.alertsystem.service;



import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.AlerteRepository;
import com.example.alertsystem.entities.Alerte;
import java.util.List;
import java.util.Optional;

@Service
public class AlerteService {
    private final AlerteRepository alerteRepository;

    public AlerteService(AlerteRepository alerteRepository) {
        this.alerteRepository = alerteRepository;
    }

    public List<Alerte> getAllAlertes() { return alerteRepository.findAll(); }
    public Optional<Alerte> getAlerteById(Long id) { return alerteRepository.findById(id); }
    public Alerte saveAlerte(Alerte alerte) { return alerteRepository.save(alerte); }
    public void deleteAlerte(Long id) { alerteRepository.deleteById(id); }
}
