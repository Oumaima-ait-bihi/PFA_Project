package com.example.alertsystem.service;

import com.example.alertsystem.entities.Admin;
import com.example.alertsystem.repository.AdminRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AdminService {
    private final AdminRepository adminRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public AdminService(AdminRepository adminRepository) {
        this.adminRepository = adminRepository;
    }

    /**
     * Create a new admin user
     * @param username the admin username (email)
     * @param password the admin password (will be encrypted)
     * @return the created Admin entity
     */
    public Admin createAdmin(String username, String password) {
        // Check if admin already exists
        if (adminRepository.findByUsername(username).isPresent()) {
            throw new RuntimeException("Admin with username " + username + " already exists");
        }

        // Create new admin
        Admin admin = new Admin();
        admin.setUsername(username);
        admin.setPassword(passwordEncoder.encode(password));
        
        return adminRepository.save(admin);
    }

    /**
     * Authenticate admin
     * @param username the admin username (email)
     * @param password the admin password
     * @return true if authenticated, false otherwise
     */
    public boolean authenticateAdmin(String username, String password) {
        return adminRepository.findByUsername(username)
                .map(admin -> passwordEncoder.matches(password, admin.getPassword()))
                .orElse(false);
    }
}

