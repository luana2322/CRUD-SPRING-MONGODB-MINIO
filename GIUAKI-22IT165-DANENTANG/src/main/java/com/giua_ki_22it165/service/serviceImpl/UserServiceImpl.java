package com.giua_ki_22it165.service.serviceImpl;

import com.giua_ki_22it165.model.Users;
import com.giua_ki_22it165.repository.UserRepository;
import com.giua_ki_22it165.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private StorageServiceImpl storageService;

    @Override
    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public Optional<Users> getByUsername(String username) {
        return userRepository.findById(username);
    }

    @Override
    public Users createUser(Users user) {
        return userRepository.save(user);
    }

    @Override
    public Optional<Users> updateUser(String username, Users updatedUser) {
        return userRepository.findById(username).map(u -> {
            u.setEmail(updatedUser.getEmail());
            u.setPassword(updatedUser.getPassword());
            u.setImage(updatedUser.getImage());
            return userRepository.save(u);
        });
    }

    @Override
    public void deleteUser(String username) {
        userRepository.deleteById(username);
    }

    @Override
    public String uploadUserImage(String username, MultipartFile file) throws Exception {
        String url = storageService.uploadFile(file);
// cập nhật image field của user
        userRepository.findById(username).ifPresent(u -> {
            u.setImage(url);
            userRepository.save(u);
        });
        return url;
    }
}
