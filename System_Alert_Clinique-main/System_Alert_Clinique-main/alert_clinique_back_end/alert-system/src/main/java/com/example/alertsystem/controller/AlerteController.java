package com.example.alertsystem.controller;



import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.AlerteService;
import com.example.alertsystem.entities.Alerte;
import com.example.alertsystem.dto.AlerteDto;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/alertes")
public class AlerteController {
    private final AlerteService alerteService;

    public AlerteController(AlerteService alerteService) {
        this.alerteService = alerteService;
    }

    @GetMapping
    public List<AlerteDto> getAllAlertes() { 
        return alerteService.getAllAlertes().stream()
            .map(AlerteDto::fromEntity)
            .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AlerteDto> getAlerteById(@PathVariable Long id) {
        return alerteService.getAlerteById(id)
                .map(AlerteDto::fromEntity)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Alerte createAlerte(@RequestBody Alerte alerte) { return alerteService.saveAlerte(alerte); }

    @DeleteMapping("/{id}")
    public void deleteAlerte(@PathVariable Long id) { alerteService.deleteAlerte(id); }
}

