package com.example.alertsystem.service;

import com.example.alertsystem.dto.AuthRequest;
import com.example.alertsystem.dto.AuthResponse;
import com.example.alertsystem.repository.PatientRepository;
import com.example.alertsystem.repository.MedecinRepository;
import com.example.alertsystem.repository.AdminRepository;
import com.example.alertsystem.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
    private final PatientRepository patientRepository;
    private final MedecinRepository medecinRepository;
    private final AdminRepository adminRepository;
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AuthService(PatientRepository patientRepository, MedecinRepository medecinRepository, AdminRepository adminRepository, UserRepository userRepository) {
        this.patientRepository = patientRepository;
        this.medecinRepository = medecinRepository;
        this.adminRepository = adminRepository;
        this.userRepository = userRepository;
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

        if ("admin".equals(userType)) {
            return authenticateAdmin(email, password);
        } else if ("patient".equals(userType)) {
            return authenticatePatient(email, password);
        } else if ("medecin".equals(userType)) {
            return authenticateMedecin(email, password);
        } else {
            return new AuthResponse(false, "Invalid user type. Must be 'admin', 'patient' or 'medecin'");
        }
    }

    private AuthResponse authenticateAdmin(String email, String password) {
        // Pour l'admin, on peut utiliser l'email ou le username
        return adminRepository.findByUsername(email)
                .or(() -> adminRepository.findAll().stream()
                        .filter(admin -> email.equals(admin.getUsername()))
                        .findFirst())
                .map(admin -> {
                    // Vérifier le mot de passe
                    if (admin.getPassword() != null && passwordEncoder.matches(password, admin.getPassword())) {
                        return new AuthResponse(
                                true,
                                "Authentication successful",
                                "admin",
                                admin.getId(),
                                admin.getUsername() != null ? admin.getUsername() : "Administrateur",
                                email, // Utiliser l'email fourni
                                null
                        );
                    } else {
                        return new AuthResponse(false, "Invalid email or password");
                    }
                })
                .orElse(new AuthResponse(false, "Admin not found with username: " + email));
    }

    private AuthResponse authenticatePatient(String email, String password) {
        // D'abord, chercher dans la table users (username = email)
        return userRepository.findByUsername(email)
                .filter(user -> "Patient".equals(user.getRole()))
                .map(user -> {
                    // Vérifier le mot de passe depuis users
                    if (user.getPassword() != null && passwordEncoder.matches(password, user.getPassword())) {
                        // Essayer de récupérer les infos complètes depuis la table patient
                        return patientRepository.findByEmail(email)
                                .map(patient -> {
                                    // Utiliser les infos complètes du patient
                                    return new AuthResponse(
                                            true,
                                            "Authentication successful",
                                            "patient",
                                            patient.getId(),
                                            patient.getName(),
                                            patient.getEmail(),
                                            patient.getPhone()
                                    );
                                })
                                .orElseGet(() -> {
                                    // Si pas dans patient, utiliser les infos de base depuis users
                                    // Extraire le nom depuis le username (email) si possible
                                    String userName = email.split("@")[0];
                                    // Capitaliser la première lettre
                                    userName = userName.substring(0, 1).toUpperCase() + userName.substring(1);
                                    
                                    return new AuthResponse(
                                            true,
                                            "Authentication successful",
                                            "patient",
                                            user.getId(),
                                            userName, // Utiliser le username comme nom
                                            email,
                                            null // Pas de téléphone dans users
                                    );
                                });
                    } else {
                        return new AuthResponse(false, "Invalid email or password");
                    }
                })
                .orElseGet(() -> {
                    // Si pas trouvé dans users, chercher directement dans patient (pour compatibilité)
                    return patientRepository.findByEmail(email)
                            .map(patient -> {
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
                });
    }

    private AuthResponse authenticateMedecin(String email, String password) {
        // D'abord, chercher dans la table users (username = email)
        return userRepository.findByUsername(email)
                .filter(user -> "Medecin".equals(user.getRole()))
                .map(user -> {
                    // Vérifier le mot de passe depuis users
                    if (user.getPassword() != null && passwordEncoder.matches(password, user.getPassword())) {
                        // Essayer de récupérer les infos complètes depuis la table medecin
                        return medecinRepository.findByEmail(email)
                                .map(medecin -> {
                                    // Utiliser les infos complètes du médecin
                                    return new AuthResponse(
                                            true,
                                            "Authentication successful",
                                            "medecin",
                                            medecin.getId(),
                                            medecin.getNom(),
                                            medecin.getEmail(),
                                            medecin.getPhone()
                                    );
                                })
                                .orElseGet(() -> {
                                    // Si pas dans medecin, utiliser les infos de base depuis users
                                    String userName = email.split("@")[0];
                                    userName = userName.substring(0, 1).toUpperCase() + userName.substring(1);
                                    
                                    return new AuthResponse(
                                            true,
                                            "Authentication successful",
                                            "medecin",
                                            user.getId(),
                                            "Dr. " + userName, // Ajouter "Dr." pour les médecins
                                            email,
                                            null
                                    );
                                });
                    } else {
                        return new AuthResponse(false, "Invalid email or password");
                    }
                })
                .orElseGet(() -> {
                    // Si pas trouvé dans users, chercher directement dans medecin (pour compatibilité)
                    return medecinRepository.findByEmail(email)
                            .map(medecin -> {
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
                });
    }
}
