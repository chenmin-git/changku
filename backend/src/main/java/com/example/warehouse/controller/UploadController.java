package com.example.warehouse.controller;

import com.example.warehouse.common.ApiResponse;
import com.example.warehouse.common.BusinessException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class UploadController {
    private static final Set<String> ALLOWED = Set.of("jpg", "jpeg", "png", "webp", "svg");

    @Value("${app.upload-dir:uploads}")
    private String uploadDir;

    @PostMapping
    public ApiResponse<Map<String, String>> upload(@RequestParam MultipartFile file,
                                                   @RequestParam(defaultValue = "common") String module) throws IOException {
        if (file.isEmpty()) {
            throw new BusinessException("请选择需要上传的图片");
        }
        String original = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String ext = original.contains(".") ? original.substring(original.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT) : "";
        if (!ALLOWED.contains(ext)) {
            throw new BusinessException("仅支持 jpg、jpeg、png、webp、svg 格式图片");
        }
        if (!module.matches("[a-zA-Z0-9_-]+")) {
            throw new BusinessException("上传模块名称不合法");
        }
        LocalDate now = LocalDate.now();
        Path root = resolveUploadRoot();
        Path dir = root.resolve(Path.of(module, String.valueOf(now.getYear()), String.format("%02d", now.getMonthValue()))).normalize();
        Files.createDirectories(dir);
        String filename = UUID.randomUUID().toString().replace("-", "") + "." + ext;
        Path target = dir.resolve(filename).normalize();
        if (!target.toAbsolutePath().startsWith(root.toAbsolutePath())) {
            throw new BusinessException("上传路径不合法");
        }
        file.transferTo(target);
        String relativePath = Path.of(uploadDir, module, String.valueOf(now.getYear()), String.format("%02d", now.getMonthValue()), filename)
                .toString()
                .replace("\\", "/");
        return ApiResponse.ok(Map.of("url", "/" + relativePath, "path", relativePath));
    }

    private Path resolveUploadRoot() {
        Path current = Path.of(uploadDir).toAbsolutePath().normalize();
        Path parent = Path.of("..", uploadDir).toAbsolutePath().normalize();
        return Files.exists(parent) ? parent : current;
    }
}
