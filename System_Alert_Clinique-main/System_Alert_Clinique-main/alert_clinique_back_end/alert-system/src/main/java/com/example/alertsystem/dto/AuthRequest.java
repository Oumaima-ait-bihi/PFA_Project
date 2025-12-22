package com.example.alertsystem.dto;

public class AuthRequest {
    private String email;
    private String password;
    private String userType; // "patient" ou "medecin"

    public AuthRequest() {
    }

    public AuthRequest(String email, String password, String userType) {
        this.email = email;
        this.password = password;
        this.userType = userType;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }
}
