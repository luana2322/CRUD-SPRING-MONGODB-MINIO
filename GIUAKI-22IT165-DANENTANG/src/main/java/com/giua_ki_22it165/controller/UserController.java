package com.giua_ki_22it165.controller;

import com.giua_ki_22it165.model.Users;
import com.giua_ki_22it165.service.serviceImpl.UserServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserServiceImpl userService;

    @GetMapping("/users")
    public List<Users> getAll() {
        return userService.getAllUsers();
    }


    @GetMapping("/users/{username}")
    public ResponseEntity<Users> getByUsername(@PathVariable String username) {
        return userService.getByUsername(username)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @PostMapping("/users")
    public ResponseEntity<Users> createUser(@RequestBody Users user) {
        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        if (userService.getByUsername(user.getUsername()).isPresent()) {
            return ResponseEntity.status(409).build(); // Conflict
        }
        Users created = userService.createUser(user);
        return ResponseEntity.ok(created);
    }


    @PutMapping("/users/{username}")
    public ResponseEntity<Users> updateUser(@PathVariable String username, @RequestBody Users user) {
        return userService.updateUser(username, user)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @DeleteMapping("/users/{username}")
    public ResponseEntity<Void> deleteUser(@PathVariable String username) {
        userService.deleteUser(username);
        return ResponseEntity.noContent().build();
    }


//@PostMapping("/auth/login")
//public ResponseEntity<User> login(@RequestBody User credentials) {
//if (credentials.getUsername() == null) return ResponseEntity.badRequest().build();
//return userService.login(credentials.getUsername(), credentials.getPassword())
//.map(ResponseEntity::ok)
//.orElse(ResponseEntity.status(401).build());
//}


    // Upload image for a user: multipart/form-data, field name = file
    @PostMapping("/users/{username}/image")
    public ResponseEntity<String> uploadImage(@PathVariable String username, @RequestParam("file") MultipartFile file) {
        try {
            String url = userService.uploadUserImage(username, file);
            return ResponseEntity.ok(url);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Upload failed: " + e.getMessage());
        }
    }

}
