package com.example.alertsystem.service;

import com.example.alertsystem.entities.Patient;
import com.example.alertsystem.repository.PatientRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;


@Service
public class PatientService {
    private final PatientRepository patientRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public PatientService(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    public Patient savePatient(Patient patient) {
        if (patient.getPassword() != null) {
            patient.setPassword(passwordEncoder.encode(patient.getPassword()));
        }
        return patientRepository.save(patient);
    }

    public Optional<Patient> getPatientById(Long id) {
        return patientRepository.findById(id);
    }

    public Optional<Patient> updatePatient(Long id, Patient patientDetails) {
        return patientRepository.findById(id).map(patient -> {
            patient.setName(patientDetails.getName());
            patient.setEmail(patientDetails.getEmail());
            patient.setPhone(patientDetails.getPhone());
            patient.setAge(patientDetails.getAge());
            patient.setGender(patientDetails.getGender());
            patient.setCondition(patientDetails.getCondition());
            patient.setStatus(patientDetails.getStatus());
            patient.setLastVisit(patientDetails.getLastVisit());
            patient.setAssignedDoctor(patientDetails.getAssignedDoctor());
            patient.setAdresse(patientDetails.getAdresse());
            if (patientDetails.getPassword() != null) {
                patient.setPassword(passwordEncoder.encode(patientDetails.getPassword()));
            }
            return patientRepository.save(patient);
        });
    }

    public void deletePatient(Long id) {
        patientRepository.deleteById(id);
    }
}
