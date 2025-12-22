package com.example.alertsystem.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Désactiver CSRF pour les API REST
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/**").permitAll() // Autoriser tous les endpoints API
                .anyRequest().authenticated() // Toutes les autres requêtes nécessitent une authentification
            );
        return http.build();
    }
}

