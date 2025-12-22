package com.example.alertsystem.controller;


import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.MedecinService;
import com.example.alertsystem.entities.Medecin;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
@RequestMapping("/api/medecins")
public class MedecinController {
    private final MedecinService medecinService;

    public MedecinController(MedecinService medecinService) {
        this.medecinService = medecinService;
    }

    /**
     * GET /api/medecins : Accès pour Admin, Medecin, Patient authentifiés
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'MEDECIN', 'PATIENT')")
    public List<Medecin> getAllMedecins() { return medecinService.getAllMedecins(); }

    /**
     * GET /api/medecins/{id} : Accès pour Admin, Medecin, Patient authentifiés
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MEDECIN', 'PATIENT')")
    public ResponseEntity<Medecin> getMedecinById(@PathVariable Long id) {
        return medecinService.getMedecinById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * POST /api/medecins : Création possible seulement par Admin
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Medecin createMedecin(@RequestBody Medecin medecin) { return medecinService.saveMedecin(medecin); }

    /**
     * PUT /api/medecins/{id} : Modification possible seulement par Admin
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Medecin> updateMedecin(@PathVariable Long id, @RequestBody Medecin medecin) {
        return medecinService.updateMedecin(id, medecin)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * DELETE /api/medecins/{id} : Suppression possible seulement par Admin
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteMedecin(@PathVariable Long id) { medecinService.deleteMedecin(id); }
}

