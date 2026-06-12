package com.example.warehouse.common;

public record ApiResponse<T>(int code, String message, T data) {
    public static <T> ApiResponse<T> ok(T data) {
        return new ApiResponse<>(200, "操作成功", data);
    }

    public static ApiResponse<Void> ok() {
        return new ApiResponse<>(200, "操作成功", null);
    }

    public static ApiResponse<Void> fail(String message) {
        return new ApiResponse<>(500, message, null);
    }
}
