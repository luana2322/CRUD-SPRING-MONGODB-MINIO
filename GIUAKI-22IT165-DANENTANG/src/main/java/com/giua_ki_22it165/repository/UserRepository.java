package com.giua_ki_22it165.repository;

import com.giua_ki_22it165.model.Users;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface UserRepository extends MongoRepository<Users, String> {
}
