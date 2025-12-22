package com.example.alertsystem.controller;



import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.AlerteService;
import com.example.alertsystem.entities.Alerte;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/alertes")
public class AlerteController {
    private final AlerteService alerteService;

    public AlerteController(AlerteService alerteService) {
        this.alerteService = alerteService;
    }

    @GetMapping
    public List<Alerte> getAllAlertes() { return alerteService.getAllAlertes(); }

    @GetMapping("/{id}")
    public ResponseEntity<Alerte> getAlerteById(@PathVariable Long id) {
        return alerteService.getAlerteById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Alerte createAlerte(@RequestBody Alerte alerte) { return alerteService.saveAlerte(alerte); }

    @DeleteMapping("/{id}")
    public void deleteAlerte(@PathVariable Long id) { alerteService.deleteAlerte(id); }
}

