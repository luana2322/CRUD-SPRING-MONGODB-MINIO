package com.giua_ki_22it165;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@EnableMongoRepositories(basePackages = "com.giua_ki_22it165.repository")
@SpringBootApplication
public class GiuaKi22it165Application {

	public static void main(String[] args) {
		SpringApplication.run(GiuaKi22it165Application.class, args);
	}

}
