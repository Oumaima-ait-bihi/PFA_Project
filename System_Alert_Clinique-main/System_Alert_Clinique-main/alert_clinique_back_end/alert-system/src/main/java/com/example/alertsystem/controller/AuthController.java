package com.example.alertsystem.controller;

import com.example.alertsystem.dto.AuthRequest;
import com.example.alertsystem.dto.AuthResponse;
import com.example.alertsystem.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Authenticate user (patient or medecin) with email and password
     * @param authRequest containing email, password, and userType (patient/medecin)
     * @return AuthResponse with user info if authenticated
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest authRequest) {
        AuthResponse response = authService.authenticate(authRequest);
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.status(401).body(response);
        }
    }
}
