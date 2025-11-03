package com.giua_ki_22it165.config;


import com.giua_ki_22it165.model.Users;
import com.giua_ki_22it165.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCrypt;

@Configuration
public class DataSeeder {

    @Bean
    CommandLineRunner initDatabase(UserRepository userRepository) {
        return args -> {
            // nếu chưa có user nào thì thêm data mẫu
            if (userRepository.count() == 0) {

                Users admin = new Users(
                        "admin",
                        "admin@gmail.com",
                        BCrypt.hashpw("123456", BCrypt.gensalt(10)),
                        "https://i.imgur.com/3GvwNBf.png"
                );

                Users user = new Users(
                        "user1",
                        "user1@gmail.com",
                        BCrypt.hashpw("123456", BCrypt.gensalt(10)),
                        "https://i.imgur.com/qQZVZ.png"
                );

                userRepository.save(admin);
                userRepository.save(user);

                System.out.println("✅ Đã seed 2 user mẫu vào MongoDB:");
                System.out.println("   ➤ admin / 123456");
                System.out.println("   ➤ user1 / 123456");
            } else {
                System.out.println("ℹ️ MongoDB đã có dữ liệu, không seed lại.");
            }
        };
    }
}