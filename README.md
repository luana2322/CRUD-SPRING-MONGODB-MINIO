# CRUD Spring Boot + MongoDB + MinIO + Flutter

A full-stack CRUD application with a **Spring Boot** backend, **MongoDB** database, **MinIO** object storage, and a **Flutter** cross-platform frontend. This project demonstrates a complete microservices architecture with Docker containerization.

## 📋 Project Overview

This project is a user management system that allows you to:
- **Create, Read, Update, Delete (CRUD)** user records
- **Upload and store** user profile images in MinIO object storage
- **Manage users** through a Flutter mobile/web application
- **Authenticate** users via login credentials
- Deploy everything using **Docker Compose** for easy setup and scaling

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Frontend                         │
│              (Web, Android, iOS, Windows)                    │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP/REST
┌────────────────────────▼────────────────────────────────────┐
│                  Spring Boot Backend                         │
│              (Port 8080 - RESTful API)                       │
├─────────────────────────────────────────────────────────────┤
│  ├─ User Management APIs                                    │
│  ├─ Image Upload & Storage                                  │
│  └─ Authentication & Validation                             │
└────────────────────────┬──────────────┬─────────────────────┘
                         │              │
          ┌──────────────▼──┐   ┌───────▼──────────────┐
          │    MongoDB      │   │    MinIO Storage     │
          │  (Port 27017)   │   │  (Port 9000/9001)    │
          └─────────────────┘   └──────────────────────┘
```

---

## 🚀 Quick Start with Docker Compose

### Prerequisites
- **Docker** and **Docker Compose** installed
- **.env** file configured with environment variables

### 1. Configure Environment Variables

Create a `.env` file in the project root:

```env
# MongoDB Configuration
MONGO_PORT=27017
MONGO_INITDB_ROOT_USERNAME=your-username
MONGO_INITDB_ROOT_PASSWORD=your-password

# MinIO Configuration
MINIO_PORT=9000
MINIO_CONSOLE_PORT=9001
MINIO_ROOT_USER=your-username
MINIO_ROOT_PASSWORD=your-password
```

### 2. Start All Services

```bash
docker-compose up -d
```

This command will start:
- **MongoDB** on `mongodb:27017`
- **MinIO** on `minio:9000` (API) and `minio:9001` (Console)
- **Spring Boot Backend** on `http://localhost:8080`
- **Flutter Frontend** on `http://localhost:8081`

### 3. Access the Services

| Service | URL | Notes |
|---------|-----|-------|
| Flutter App | `http://localhost:8081` | User interface |
| Backend API | `http://localhost:8080` | REST API endpoints |
| MinIO Console | `http://localhost:9001` | Storage management UI |
| MongoDB | `mongodb:27017` | Database (internal) |

---

## 🛠️ Backend - Spring Boot

### Technology Stack
- **Spring Boot 3.5.7**
- **Java 17**
- **MongoDB** - NoSQL database
- **MinIO 8.5.3** - Object storage service
- **Maven** - Dependency management

### Project Structure
```
GIUAKI-22IT165-DANENTANG/
├── src/main/
│   ├── java/com/giua_ki_22it165/
│   │   ├── GiuaKi22it165Application.java     # Main Spring Boot class
│   │   ├── config/
│   │   │   ├── MinioConfig.java              # MinIO configuration
│   │   │   ├── WebConfig.java                # Web CORS configuration
│   │   │   ├── PasswordUtil.java             # Password encryption utility
│   │   │   ├── AESUtil.java                  # AES encryption utility
│   │   │   └── DataSeeder.java               # Initial data loader
│   │   ├── controller/
│   │   │   └── UserController.java           # REST API endpoints
│   │   ├── model/
│   │   │   └── Users.java                    # User entity
│   │   ├── repository/
│   │   │   └── UserRepository.java           # MongoDB repository
│   │   ├── service/
│   │   │   ├── UserService.java              # User service interface
│   │   │   ├── StorageService.java           # Storage service interface
│   │   │   └── serviceImpl/
│   │   │       ├── UserServiceImpl.java       # User business logic implementation
│   │   │       └── StorageServiceImpl.java    # MinIO storage logic implementation
│   └── resources/
│       └── application.properties             # Spring configuration
├── pom.xml                                    # Maven dependencies
└── Dockerfile                                 # Docker image config
```

### Key Dependencies
```xml
<!-- Spring Data MongoDB -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>

<!-- MinIO Client -->
<dependency>
    <groupId>io.minio</groupId>
    <artifactId>minio</artifactId>
    <version>8.5.3</version>
</dependency>

<!-- Security (Password Encryption) -->
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-crypto</artifactId>
</dependency>
```

### API Endpoints

#### Get All Users
```http
GET /api/users
```
Response: List of all users

#### Get User by Username
```http
GET /api/users/{username}
```

#### Create User
```http
POST /api/users
Content-Type: application/json

{
    "username": "john_doe",
    "password": "secure_password",
    "email": "john@example.com",
    "fullName": "John Doe"
}
```

#### Update User
```http
PUT /api/users/{username}
Content-Type: application/json

{
    "email": "newemail@example.com",
    "fullName": "John Updated"
}
```

#### Delete User
```http
DELETE /api/users/{username}
```

#### Upload User Profile Image
```http
POST /api/users/{username}/image
Content-Type: multipart/form-data

file: <image_file>
```
Returns: URL to the uploaded image in MinIO

### Running Locally

```bash
cd GIUAKI-22IT165-DANENTANG

# Build
mvn clean install

# Run
mvn spring-boot:run
```

Backend will start on `http://localhost:8080`

---

## 📱 Frontend - Flutter

### Technology Stack
- **Flutter 3.10+**
- **Dart 3.10+**
- **Provider** - State management
- **Dio** - HTTP client
- **SharedPreferences** - Local storage
- **ImagePicker** - Image selection

### Project Structure
```
flutter_crud/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── user_model.dart         # User data model
│   ├── providers/
│   │   └── user_provider.dart      # Provider for state management
│   ├── screens/
│   │   ├── login_screen.dart       # Login UI
│   │   └── user_list_screen.dart   # User management UI
│   ├── services/
│   │   └── api_service.dart        # API client
│   ├── utils/
│   └── widgets/
│       └── custom_widgets.dart     # Reusable UI components
├── pubspec.yaml                     # Dependencies
├── Dockerfile                       # Docker image config
└── analysis_options.yaml            # Linting rules
```

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  dio: ^5.4.0                        # HTTP client for API calls
  provider: ^6.1.1                   # State management
  shared_preferences: ^2.2.2         # Local data persistence
  image_picker: ^1.0.4               # Image selection from device
  cupertino_icons: ^1.0.8            # iOS-style icons
```

### Features

1. **Login Screen**
   - User authentication
   - Credential validation
   - Session persistence

2. **User List Screen**
   - Display all users
   - Create new user
   - Edit user details
   - Delete user
   - Upload user profile image

3. **State Management**
   - Provider pattern for reactive updates
   - Centralized user data management

### Running Locally

```bash
cd flutter_crud

# Get dependencies
flutter pub get

# Run app
flutter run -d chrome          # Web
flutter run -d emulator        # Android emulator
flutter run -d ios-simulator   # iOS simulator
```

---

## 🐳 Docker Configuration

### docker-compose.yml

The `docker-compose.yml` orchestrates all services:

```yaml
services:
  mongodb:
    - Stores user data
    - Persistent volume at C:/Program Files/MongoDB/Server/8.2/data
    
  minio:
    - Object storage for user images
    - Console UI at port 9001
    
  backend:
    - Spring Boot REST API
    - Depends on MongoDB and MinIO
    - Environment variables for database and storage connections
    
  frontend:
    - Flutter web application
    - Connects to backend on port 8080
```

### Build Custom Images

```bash
# Build backend image
docker build -t spring-backend ./GIUAKI-22IT165-DANENTANG

# Build frontend image
docker build -t flutter-frontend ./flutter_crud

# Start all services
docker-compose up -d
```

---

## 📊 MongoDB Collections

### Users Collection

```json
{
    "_id": ObjectId("..."),
    "username": "john_doe",
    "password": "$2a$10$...",           // Encrypted password
    "email": "john@example.com",
    "fullName": "John Doe",
    "imageUrl": "http://minio:9000/...",
    "createdAt": ISODate("2024-11-11"),
    "updatedAt": ISODate("2024-11-11")
}
```

---

## 💾 MinIO Storage

### Bucket Structure

```
minio/
└── user-images/
    ├── john_doe_profile.jpg
    ├── jane_smith_profile.png
    └── ...
```

**Access**: Images are accessible via `http://minio:9000/user-images/{image_name}`

---

## 🔐 Security Features

1. **Password Encryption**
   - Using Spring Security's BCryptPasswordEncoder
   - Passwords are hashed before storage

2. **API Security**
   - CORS enabled for cross-origin requests
   - Input validation on user creation/update

3. **Data Validation**
   - Username uniqueness check
   - Email format validation
   - Required field validation

---

## 🧪 Testing

### Backend (Spring Boot)

```bash
cd GIUAKI-22IT165-DANENTANG
mvn test
```

### Frontend (Flutter)

```bash
cd flutter_crud
flutter test
```

---

## 📝 Environment Variables

Create a `.env` file with the following variables:

```env
# MongoDB
MONGO_PORT=27017
MONGO_INITDB_ROOT_USERNAME=your-username
MONGO_INITDB_ROOT_PASSWORD=your-password

# MinIO
MINIO_PORT=9000
MINIO_CONSOLE_PORT=9001
MINIO_ROOT_USER=your-username
MINIO_ROOT_PASSWORD=your-password
```

---

## 🛠️ Troubleshooting

### MongoDB Connection Issues
- Ensure MongoDB is running and accessible
- Check connection string in `application.properties`
- Verify credentials in `.env`

### MinIO Connection Issues
- Access MinIO console: `http://localhost:9001`
- Verify credentials and bucket configuration
- Check MinIO logs: `docker logs minio`

### Backend Not Starting
```bash
# Check logs
docker logs spring-backend

# Rebuild
docker-compose up -d --build backend
```

### Flutter App Not Connecting
- Ensure backend is running on `http://localhost:8080`
- Check network settings and firewall
- Update API base URL in `api_service.dart` if needed

---

## 📦 Deployment

### Production Checklist
- [ ] Update `.env` with production credentials
- [ ] Use strong passwords
- [ ] Enable HTTPS
- [ ] Set up proper MongoDB backups
- [ ] Configure MinIO access policies
- [ ] Set resource limits in docker-compose.yml
- [ ] Use health checks for services

### Scale Up
```bash
# Scale backend to 3 instances
docker-compose up -d --scale backend=3
```

---

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [MongoDB Documentation](https://docs.mongodb.com)
- [MinIO Documentation](https://min.io/docs)
- [Docker Compose Documentation](https://docs.docker.com/compose)

---

## 👨‍💻 Developer

**ME**

---

## 📄 License

This project is provided as-is for educational purposes.

---

## 🤝 Contributing

Feel free to fork this project and submit pull requests for improvements!

---

**Last Updated**: November 11, 2025
