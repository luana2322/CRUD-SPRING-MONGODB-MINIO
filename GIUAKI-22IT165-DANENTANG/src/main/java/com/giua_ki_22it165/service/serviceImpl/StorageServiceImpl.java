package com.giua_ki_22it165.service.serviceImpl;

import com.giua_ki_22it165.service.StorageService;
import io.minio.GetPresignedObjectUrlArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.http.Method;
import org.springframework.beans.factory.annotation.Value;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class StorageServiceImpl implements StorageService {
    private final MinioClient minioClient;


    @Value("${minio.bucket}")
    private String bucketName;


    public StorageServiceImpl(MinioClient minioClient) {
        this.minioClient = minioClient;
    }

    @Override
    public String uploadFile(MultipartFile file) throws Exception {
        String ext = FilenameUtils.getExtension(file.getOriginalFilename());
        String objectName = UUID.randomUUID().toString() + (ext.isEmpty() ? "" : "." + ext);


        try (InputStream is = file.getInputStream()) {
            minioClient.putObject(
                    PutObjectArgs.builder()
                            .bucket(bucketName)
                            .object(objectName)
                            .stream(is, file.getSize(), -1)
                            .contentType(file.getContentType())
                            .build()
            );
        }


// Tạo presigned URL (public trong thời gian ngắn) hoặc nếu bucket public thì có thể build URL trực tiếp
        String url = minioClient.getPresignedObjectUrl(
                GetPresignedObjectUrlArgs.builder()
                        .method(Method.GET)
                        .bucket(bucketName)
                        .object(objectName)
                        .expiry(7, TimeUnit.DAYS) // URL hợp lệ 7 ngày
                        .build()
        );


        return url;
    }
}
