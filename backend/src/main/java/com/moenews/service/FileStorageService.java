package com.moenews.service;

import com.moenews.exception.BizException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Service
public class FileStorageService {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png");

    @Value("${moenews.upload.path}")
    private String uploadPath;

    public Map<String, String> uploadImage(MultipartFile file) {
        if (file.isEmpty()) {
            throw new BizException("请选择图片文件");
        }
        String original = file.getOriginalFilename();
        String extension = original == null || !original.contains(".")
                ? ""
                : original.substring(original.lastIndexOf('.') + 1).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new BizException("只允许上传 jpg、jpeg、png 图片");
        }
        String dateDir = LocalDate.now().toString();
        String filename = UUID.randomUUID() + "." + extension;
        Path dir = Path.of(uploadPath, dateDir);
        try {
            Files.createDirectories(dir);
            file.transferTo(dir.resolve(filename));
        } catch (IOException e) {
            throw new BizException("图片保存失败");
        }
        String url = "/uploads/" + dateDir + "/" + filename;
        return Map.of("url", url);
    }
}
