package com.example.alertsystem.service;



import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.HistoriqueAlerteRepository;
import com.example.alertsystem.entities.HistoriqueAlerte;
import java.util.List;
import java.util.Optional;

@Service
public class HistoriqueAlerteService {
    private final HistoriqueAlerteRepository repository;

    public HistoriqueAlerteService(HistoriqueAlerteRepository repository) {
        this.repository = repository;
    }

    public List<HistoriqueAlerte> getAll() { return repository.findAll(); }
    public Optional<HistoriqueAlerte> getById(Long id) { return repository.findById(id); }
    public HistoriqueAlerte save(HistoriqueAlerte ha) { return repository.save(ha); }
    public void delete(Long id) { repository.deleteById(id); }
}

