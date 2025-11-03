package com.giua_ki_22it165.repository;

import com.giua_ki_22it165.model.Users;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<Users, String> {
       // 🔍 Tìm user theo username (dùng cho login, upload ảnh, v.v.)
    Optional<Users> findByUsername(String username);

    void deleteByUsername(String username);
    // ✅ Kiểm tra username đã tồn tại (dùng khi tạo tài khoản mới)
    boolean existsByUsername(String username);
}
