package com.example.alertsystem.service;



import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.HumeurRepository;
import com.example.alertsystem.entities.Humeur;
import java.util.List;
import java.util.Optional;

@Service
public class HumeurService {
    private final HumeurRepository repository;

    public HumeurService(HumeurRepository repository) {
        this.repository = repository;
    }

    public List<Humeur> getAll() { return repository.findAll(); }
    public Optional<Humeur> getById(Long id) { return repository.findById(id); }
    public Humeur save(Humeur h) { return repository.save(h); }
    public void delete(Long id) { repository.deleteById(id); }
}

