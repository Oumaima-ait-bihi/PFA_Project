package com.example.alertsystem.controller;



import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.HumeurService;
import com.example. alertsystem.entities.Humeur;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/humeurs")
public class HumeurController {
    private final HumeurService service;

    public HumeurController(HumeurService service) { this.service = service; }

    @GetMapping
    public List<Humeur> getAll() { return service.getAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Humeur> getById(@PathVariable Long id) {
        return service.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Humeur create(@RequestBody Humeur h) { return service.save(h); }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { service.delete(id); }
}

