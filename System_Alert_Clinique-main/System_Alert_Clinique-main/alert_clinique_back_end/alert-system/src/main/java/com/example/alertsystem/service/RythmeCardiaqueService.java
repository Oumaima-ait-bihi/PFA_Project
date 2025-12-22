package com.example.alertsystem.service;


import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.RythmeCardiaqueRepository;
import com.example.alertsystem.entities.RythmeCardiaque;
import java.util.List;
import java.util.Optional;

@Service
public class RythmeCardiaqueService {
    private final RythmeCardiaqueRepository repository;

    public RythmeCardiaqueService(RythmeCardiaqueRepository repository) {
        this.repository = repository;
    }

    public List<RythmeCardiaque> getAll() { return repository.findAll(); }
    public Optional<RythmeCardiaque> getById(Long id) { return repository.findById(id); }
    public RythmeCardiaque save(RythmeCardiaque rc) { return repository.save(rc); }
    public void delete(Long id) { repository.deleteById(id); }
}
