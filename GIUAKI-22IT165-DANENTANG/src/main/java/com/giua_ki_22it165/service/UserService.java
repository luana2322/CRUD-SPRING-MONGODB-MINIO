package com.giua_ki_22it165.service;

import com.giua_ki_22it165.model.Users;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

public interface UserService {
    public List<Users> getAllUsers();
public Optional<Users> getByUsername(String username);
public Users createUser(Users user);
public Optional<Users> updateUser(String username, Users updatedUser);
public void deleteUser(String username);
public String uploadUserImage(String username, MultipartFile file) throws Exception;
public Optional<Users> login(String username, String password);
}
