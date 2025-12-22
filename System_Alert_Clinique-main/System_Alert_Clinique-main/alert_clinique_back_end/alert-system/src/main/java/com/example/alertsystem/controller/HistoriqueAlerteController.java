package com.example.alertsystem.controller;


import org.springframework.web.bind.annotation.*;
import com.example. alertsystem.service.HistoriqueAlerteService;
import com.example.alertsystem.entities.HistoriqueAlerte;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/historiqueAlertes")
public class HistoriqueAlerteController {
    private final HistoriqueAlerteService service;

    public HistoriqueAlerteController(HistoriqueAlerteService service) { this.service = service; }

    @GetMapping
    public List<HistoriqueAlerte> getAll() { return service.getAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<HistoriqueAlerte> getById(@PathVariable Long id) {
        return service.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public HistoriqueAlerte create(@RequestBody HistoriqueAlerte ha) { return service.save(ha); }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { service.delete(id); }
}

