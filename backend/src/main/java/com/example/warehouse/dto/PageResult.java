package com.example.warehouse.dto;

import java.util.List;
import java.util.Map;

public record PageResult(long total, int page, int size, List<Map<String, Object>> records) {
}
