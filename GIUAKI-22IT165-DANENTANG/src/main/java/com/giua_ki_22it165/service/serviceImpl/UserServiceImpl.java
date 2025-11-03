package com.giua_ki_22it165.service.serviceImpl;

import com.giua_ki_22it165.model.Users;
import com.giua_ki_22it165.repository.UserRepository;
import com.giua_ki_22it165.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
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
        // 🔒 Hash mật khẩu trước khi lưu
        String hashed = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(10));
        user.setPassword(hashed);
        return userRepository.save(user);
    }

    @Override
    public Optional<Users> updateUser(String username, Users updatedUser) {
        return userRepository.findByUsername(username).map(u -> {
            u.setEmail(updatedUser.getEmail());
                u.setUsername(updatedUser.getUsername());
                u.setEmail(updatedUser.getEmail());
            if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {
                // Hash lại nếu có thay đổi mật khẩu
                String hashed = BCrypt.hashpw(updatedUser.getPassword(), BCrypt.gensalt(10));
                u.setPassword(hashed);
            }
            u.setImage(updatedUser.getImage());
            return userRepository.save(u);
        });
    }

    @Override
    public void deleteUser(String username) {
           userRepository.findByUsername(username).ifPresent(userRepository::delete);
    }


@Override
public String uploadUserImage(String username, MultipartFile file) throws Exception {
    String url = storageService.uploadFile(file);
    userRepository.findByUsername(username).ifPresent(u -> {

        u.setImage(url);
        userRepository.save(u);
    });
    return url;
}


@Override
public Optional<Users> login(String username, String password) {
    Optional<Users> userOpt = userRepository.findByUsername(username);

    if (userOpt.isPresent()) {
        Users user = userOpt.get();
        if (BCrypt.checkpw(password, user.getPassword())) {
            return Optional.of(user);
        }
    }else {
       System.out.print("chưa find được");
    }
    return Optional.empty();
}

}
