package com.giua_ki_22it165.service;

import io.minio.MinioClient;
import org.springframework.web.multipart.MultipartFile;

public interface StorageService {
public String uploadFile(MultipartFile file) throws Exception;

}
