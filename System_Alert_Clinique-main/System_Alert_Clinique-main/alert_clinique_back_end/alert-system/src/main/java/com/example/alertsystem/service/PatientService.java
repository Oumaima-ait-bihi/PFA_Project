package com.example.alertsystem.service;

import com.example.alertsystem.entities.Patient;
import com.example.alertsystem.entities.PatientUser;
import com.example.alertsystem.repository.PatientRepository;
import com.example.alertsystem.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;


@Service
public class PatientService {
    private final PatientRepository patientRepository;
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public PatientService(PatientRepository patientRepository, UserRepository userRepository) {
        this.patientRepository = patientRepository;
        this.userRepository = userRepository;
    }

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    @Transactional
    public Patient savePatient(Patient patient) {
        // Encoder le mot de passe si fourni
        String encodedPassword = null;
        if (patient.getPassword() != null && !patient.getPassword().trim().isEmpty()) {
            encodedPassword = passwordEncoder.encode(patient.getPassword());
            patient.setPassword(encodedPassword);
        }
        
        // Sauvegarder le patient
        Patient savedPatient = patientRepository.save(patient);
        
        // Créer aussi un utilisateur dans la table users pour l'authentification
        // Vérifier d'abord si l'utilisateur existe déjà
        Optional<com.example.alertsystem.entities.User> existingUser = userRepository.findByUsername(patient.getEmail());
        if (existingUser.isEmpty()) {
            // Créer un nouvel utilisateur PatientUser dans la table users
            PatientUser patientUser = new PatientUser();
            patientUser.setUsername(patient.getEmail()); // Utiliser l'email comme username
            patientUser.setPassword(encodedPassword != null ? encodedPassword : passwordEncoder.encode("defaultPassword123")); // Mot de passe par défaut si non fourni
            userRepository.save(patientUser);
        }
        
        return savedPatient;
    }

    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    @Transactional
    public Optional<Patient> updatePatient(Long id, Patient patientDetails) {
        return patientRepository.findById(id).map(patient -> {
            String oldEmail = patient.getEmail();
            String newEmail = patientDetails.getEmail();
            
            patient.setName(patientDetails.getName());
            patient.setEmail(newEmail);
            patient.setPhone(patientDetails.getPhone());
            patient.setAge(patientDetails.getAge());
            patient.setGender(patientDetails.getGender());
            patient.setCondition(patientDetails.getCondition());
            patient.setStatus(patientDetails.getStatus());
            patient.setLastVisit(patientDetails.getLastVisit());
            patient.setAssignedDoctor(patientDetails.getAssignedDoctor());
            patient.setAdresse(patientDetails.getAdresse());
            
            final String encodedPassword;
            if (patientDetails.getPassword() != null && !patientDetails.getPassword().trim().isEmpty()) {
                encodedPassword = passwordEncoder.encode(patientDetails.getPassword());
                patient.setPassword(encodedPassword);
            } else {
                encodedPassword = null;
            }
            
            Patient savedPatient = patientRepository.save(patient);
            
            // Mettre à jour aussi l'utilisateur dans la table users si l'email a changé ou le mot de passe
            final String finalEncodedPassword = encodedPassword;
            if (!oldEmail.equals(newEmail) || finalEncodedPassword != null) {
                userRepository.findByUsername(oldEmail).ifPresent(user -> {
                    user.setUsername(newEmail);
                    if (finalEncodedPassword != null) {
                        user.setPassword(finalEncodedPassword);
                    }
                    userRepository.save(user);
                });
            }
            
            return savedPatient;
        });
    }

    public void deletePatient(Long id) {
        patientRepository.deleteById(id);
    }
}
