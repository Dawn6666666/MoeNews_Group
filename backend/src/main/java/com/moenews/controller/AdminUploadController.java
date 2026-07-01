package com.moenews.controller;

import com.moenews.common.Result;
import com.moenews.service.FileStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/admin/upload")
@RequiredArgsConstructor
public class AdminUploadController {
    private final FileStorageService fileStorageService;

    @PostMapping("/image")
    public Result<Map<String, String>> image(@RequestParam("file") MultipartFile file) {
        return Result.ok(fileStorageService.uploadImage(file));
    }
}
