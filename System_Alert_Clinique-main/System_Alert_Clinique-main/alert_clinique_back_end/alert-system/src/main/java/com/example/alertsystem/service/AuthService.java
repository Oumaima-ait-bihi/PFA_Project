package com.example.alertsystem.service;

import com.example.alertsystem.dto.AuthRequest;
import com.example.alertsystem.dto.AuthResponse;
import com.example.alertsystem.entities.Patient;
import com.example.alertsystem.entities.Medecin;
import com.example.alertsystem.repository.PatientRepository;
import com.example.alertsystem.repository.MedecinRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final PatientRepository patientRepository;
    private final MedecinRepository medecinRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AuthService(PatientRepository patientRepository, MedecinRepository medecinRepository) {
        this.patientRepository = patientRepository;
        this.medecinRepository = medecinRepository;
    }

    /**
     * Authenticate user (patient or medecin) based on email and password
     * @param authRequest containing email, password, and userType (patient/medecin)
     * @return AuthResponse with user info if authenticated, otherwise error message
     */
    public AuthResponse authenticate(AuthRequest authRequest) {
        if (authRequest.getEmail() == null || authRequest.getEmail().trim().isEmpty()) {
            return new AuthResponse(false, "Email is required");
        }
        if (authRequest.getPassword() == null || authRequest.getPassword().trim().isEmpty()) {
            return new AuthResponse(false, "Password is required");
        }
        if (authRequest.getUserType() == null || authRequest.getUserType().trim().isEmpty()) {
            return new AuthResponse(false, "User type (patient/medecin) is required");
        }

        String userType = authRequest.getUserType().toLowerCase();
        String email = authRequest.getEmail().trim();
        String password = authRequest.getPassword();

        if ("patient".equals(userType)) {
            return authenticatePatient(email, password);
        } else if ("medecin".equals(userType)) {
            return authenticateMedecin(email, password);
        } else {
            return new AuthResponse(false, "Invalid user type. Must be 'patient' or 'medecin'");
        }
    }

    private AuthResponse authenticatePatient(String email, String password) {
        return patientRepository.findByEmail(email)
                .map(patient -> {
                    // Verify password
                    if (patient.getPassword() != null && passwordEncoder.matches(password, patient.getPassword())) {
                        return new AuthResponse(
                                true,
                                "Authentication successful",
                                "patient",
                                patient.getId(),
                                patient.getName(),
                                patient.getEmail(),
                                patient.getPhone()
                        );
                    } else {
                        return new AuthResponse(false, "Invalid email or password");
                    }
                })
                .orElse(new AuthResponse(false, "Patient not found with email: " + email));
    }

    private AuthResponse authenticateMedecin(String email, String password) {
        return medecinRepository.findByEmail(email)
                .map(medecin -> {
                    // Verify password
                    if (medecin.getPassword() != null && passwordEncoder.matches(password, medecin.getPassword())) {
                        return new AuthResponse(
                                true,
                                "Authentication successful",
                                "medecin",
                                medecin.getId(),
                                medecin.getNom(),
                                medecin.getEmail(),
                                medecin.getPhone()
                        );
                    } else {
                        return new AuthResponse(false, "Invalid email or password");
                    }
                })
                .orElse(new AuthResponse(false, "Medecin not found with email: " + email));
    }
}
