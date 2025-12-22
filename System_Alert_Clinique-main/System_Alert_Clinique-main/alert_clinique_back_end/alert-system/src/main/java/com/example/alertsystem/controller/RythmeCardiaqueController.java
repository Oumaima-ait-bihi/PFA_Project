package com.example.alertsystem.controller;



import org.springframework.web.bind.annotation.*;
import com.example.alertsystem.service.RythmeCardiaqueService;
import com.example.alertsystem.entities.RythmeCardiaque;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/api/rythmes")
public class RythmeCardiaqueController {
    private final RythmeCardiaqueService service;

    public RythmeCardiaqueController(RythmeCardiaqueService service) {
        this.service = service;
    }

    @GetMapping
    public List<RythmeCardiaque> getAll() { return service.getAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<RythmeCardiaque> getById(@PathVariable Long id) {
        return service.getById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public RythmeCardiaque create(@RequestBody RythmeCardiaque rc) { return service.save(rc); }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) { service.delete(id); }
}

