package com.example.alertsystem.controller;



import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.QualiteSommeilService;
import com.example.alertsystem.entities.QualiteSommeil;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/sommeils")
public class QualiteSommeilController {
    private final QualiteSommeilService service;

    public QualiteSommeilController(QualiteSommeilService service) {
        this.service = service;
    }

    @GetMapping
    public List<QualiteSommeil> getAll() { return service.getAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<QualiteSommeil> getById(@PathVariable Long id) {
        return service.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public QualiteSommeil create(@RequestBody QualiteSommeil qs) { return service.save(qs); }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { service.delete(id); }
}
