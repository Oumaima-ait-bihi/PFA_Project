package com.example.alertsystem.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import com.example.alertsystem.repository.MedecinRepository;
import com.example.alertsystem.entities.Medecin;
import java.util.List;
import java.util.Optional;

@Service
public class MedecinService {
    private final MedecinRepository medecinRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public MedecinService(MedecinRepository medecinRepository) {
        this.medecinRepository = medecinRepository;
    }

    public List<Medecin> getAllMedecins() { return medecinRepository.findAll(); }
    public Optional<Medecin> getMedecinById(Long id) { return medecinRepository.findById(id); }
    public Medecin saveMedecin(Medecin medecin) {
        if (medecin.getPassword() != null) {
            medecin.setPassword(passwordEncoder.encode(medecin.getPassword()));
        }
        return medecinRepository.save(medecin);
    }
    
    public Optional<Medecin> updateMedecin(Long id, Medecin medecinDetails) {
        return medecinRepository.findById(id).map(medecin -> {
            medecin.setNom(medecinDetails.getNom());
            medecin.setSpecialite(medecinDetails.getSpecialite());
            medecin.setEmail(medecinDetails.getEmail());
            medecin.setPhone(medecinDetails.getPhone());
            if (medecinDetails.getPassword() != null) {
                medecin.setPassword(passwordEncoder.encode(medecinDetails.getPassword()));
            }
            return medecinRepository.save(medecin);
        });
    }
    
    public void deleteMedecin(Long id) { medecinRepository.deleteById(id); }
}

