package com.example.warehouse.controller;

import com.example.warehouse.common.ApiResponse;
import com.example.warehouse.dto.PageResult;
import com.example.warehouse.service.CrudService;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/{module}")
public class CrudController {
    private final CrudService crudService;

    public CrudController(CrudService crudService) {
        this.crudService = crudService;
    }

    @GetMapping
    public ApiResponse<PageResult> page(@PathVariable String module,
                                        @RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "10") int size,
                                        @RequestParam(required = false) String keyword,
                                        @RequestParam Map<String, String> params) {
        params.remove("page");
        params.remove("size");
        params.remove("keyword");
        return ApiResponse.ok(crudService.page(module, page, size, keyword, params));
    }

    @GetMapping("/{id}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable String module, @PathVariable Long id) {
        return ApiResponse.ok(crudService.detail(module, id));
    }

    @PostMapping
    public ApiResponse<Map<String, Object>> create(@PathVariable String module, @RequestBody Map<String, Object> body) {
        return ApiResponse.ok(crudService.create(module, body));
    }

    @PutMapping("/{id}")
    public ApiResponse<Void> update(@PathVariable String module, @PathVariable Long id, @RequestBody Map<String, Object> body) {
        crudService.update(module, id, body);
        return ApiResponse.ok();
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable String module, @PathVariable Long id) {
        crudService.delete(module, id);
        return ApiResponse.ok();
    }

    @PostMapping("/batch-delete")
    public ApiResponse<Void> batchDelete(@PathVariable String module, @RequestBody Map<String, List<Long>> body) {
        crudService.batchDelete(module, body.get("ids"));
        return ApiResponse.ok();
    }

    @PostMapping("/{id}/flow")
    public ApiResponse<Void> flow(@PathVariable String module, @PathVariable Long id, @RequestBody Map<String, String> body) {
        crudService.flow(module, id, body.get("action"));
        return ApiResponse.ok();
    }
}
