package com.example.alertsystem.service;



import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.QualiteSommeilRepository;
import com.example.alertsystem.entities.QualiteSommeil;
import java.util.List;
import java.util.Optional;

@Service
public class QualiteSommeilService {
    private final QualiteSommeilRepository repository;

    public QualiteSommeilService(QualiteSommeilRepository repository) {
        this.repository = repository;
    }

    public List<QualiteSommeil> getAll() { return repository.findAll(); }
    public Optional<QualiteSommeil> getById(Long id) { return repository.findById(id); }
    public QualiteSommeil save(QualiteSommeil qs) { return repository.save(qs); }
    public void delete(Long id) { repository.deleteById(id); }
}

