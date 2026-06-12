package com.example.warehouse.controller;

import com.example.warehouse.common.ApiResponse;
import com.example.warehouse.config.AuthContext;
import com.example.warehouse.dto.LoginRequest;
import com.example.warehouse.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request));
    }

    @PostMapping("/register")
    public ApiResponse<Map<String, Object>> register() {
        return ApiResponse.ok(Map.of("message", "演示系统请使用管理员创建账号"));
    }

    @GetMapping("/profile")
    public ApiResponse<Object> profile() {
        return ApiResponse.ok(AuthContext.get());
    }
}
