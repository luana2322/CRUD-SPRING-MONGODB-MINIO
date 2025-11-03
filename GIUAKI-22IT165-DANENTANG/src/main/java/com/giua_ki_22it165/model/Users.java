package com.giua_ki_22it165.model;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.annotation.Id;

@Data
@Document(collection = "users")
public class Users {
        @Id
    private String id;

private String username;
private String email;
private String password;
private String image;
   public Users() {
    }

    // --- Constructor đầy đủ tham số ---
    public Users(String username, String email, String password, String image) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.image = image;
    }

    // --- Getter & Setter ---
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

}
