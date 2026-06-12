package com.example.warehouse.service;

import com.example.warehouse.common.BusinessException;
import com.example.warehouse.config.AuthContext;
import com.example.warehouse.dto.AuthUser;
import com.example.warehouse.dto.PageResult;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CrudService {
    private final JdbcTemplate jdbcTemplate;
    private final AuthService authService;

    public CrudService(JdbcTemplate jdbcTemplate, AuthService authService) {
        this.jdbcTemplate = jdbcTemplate;
        this.authService = authService;
    }

    public PageResult page(String module, int page, int size, String keyword, Map<String, String> filters) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(size, 1), 100);
        List<Object> params = new ArrayList<>();
        String where = buildWhere(meta, keyword, filters, params);
        Long total = jdbcTemplate.queryForObject("select count(*) from " + meta.table() + where, Long.class, params.toArray());
        params.add((safePage - 1) * safeSize);
        params.add(safeSize);
        List<Map<String, Object>> records = jdbcTemplate.queryForList(
                "select * from " + meta.table() + where + " order by id desc limit ?, ?",
                params.toArray()
        );
        return new PageResult(total == null ? 0 : total, safePage, safeSize, records);
    }

    public Map<String, Object> detail(String module, Long id) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        List<Map<String, Object>> rows = jdbcTemplate.queryForList("select * from " + meta.table() + " where id = ?", id);
        if (rows.isEmpty()) {
            throw new BusinessException(meta.label() + "不存在");
        }
        return rows.getFirst();
    }

    @Transactional
    public Map<String, Object> create(String module, Map<String, Object> body) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        Map<String, Object> data = cleanBody(body, false);
        data.putIfAbsent("created_at", LocalDateTime.now());
        data.putIfAbsent("updated_at", LocalDateTime.now());
        String columns = String.join(",", data.keySet());
        String holders = data.keySet().stream().map(k -> "?").collect(Collectors.joining(","));
        jdbcTemplate.update("insert into " + meta.table() + " (" + columns + ") values (" + holders + ")", data.values().toArray());
        log("新增", meta.label());
        return Map.of("id", jdbcTemplate.queryForObject("select last_insert_id()", Long.class));
    }

    @Transactional
    public void update(String module, Long id, Map<String, Object> body) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        Map<String, Object> data = cleanBody(body, true);
        data.put("updated_at", LocalDateTime.now());
        String sets = data.keySet().stream().map(k -> k + " = ?").collect(Collectors.joining(","));
        List<Object> params = new ArrayList<>(data.values());
        params.add(id);
        jdbcTemplate.update("update " + meta.table() + " set " + sets + " where id = ?", params.toArray());
        log("编辑", meta.label());
    }

    @Transactional
    public void delete(String module, Long id) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        jdbcTemplate.update("delete from " + meta.table() + " where id = ?", id);
        log("删除", meta.label());
    }

    @Transactional
    public void batchDelete(String module, List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            throw new BusinessException("请选择需要删除的数据");
        }
        ids.forEach(id -> delete(module, id));
    }

    @Transactional
    public void flow(String module, Long id, String action) {
        ModuleRegistry.ModuleMeta meta = checkedMeta(module);
        String status = switch (module + ":" + action) {
            case "inbounds:approve" -> "已入库";
            case "inbounds:reject" -> "已驳回";
            case "outbounds:ship" -> "已出库";
            case "outbounds:cancel" -> "已取消";
            case "checks:finish" -> "已完成";
            case "alerts:handle" -> "已处理";
            default -> throw new BusinessException("当前业务操作不支持");
        };
        int updated = jdbcTemplate.update("update " + meta.table() + " set status = ?, updated_at = ? where id = ?",
                status, LocalDateTime.now(), id);
        if (updated == 0) {
            throw new BusinessException(meta.label() + "不存在");
        }
        log("业务处理", meta.label());
    }

    private ModuleRegistry.ModuleMeta checkedMeta(String module) {
        ModuleRegistry.ModuleMeta meta;
        try {
            meta = ModuleRegistry.get(module);
        } catch (IllegalArgumentException ex) {
            throw new BusinessException(ex.getMessage());
        }
        AuthUser user = AuthContext.get();
        if (meta.adminOnly()) {
            authService.requireAdmin(user);
        }
        return meta;
    }

    private String buildWhere(ModuleRegistry.ModuleMeta meta, String keyword, Map<String, String> filters, List<Object> params) {
        List<String> clauses = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            String like = "%" + keyword.trim() + "%";
            clauses.add("(" + meta.searchable().stream().map(col -> col + " like ?").collect(Collectors.joining(" or ")) + ")");
            meta.searchable().forEach(col -> params.add(like));
        }
        if (filters != null) {
            filters.forEach((key, value) -> {
                if (meta.filterable().contains(key) && value != null && !value.isBlank()) {
                    clauses.add(key + " = ?");
                    params.add(value);
                }
            });
        }
        return clauses.isEmpty() ? "" : " where " + String.join(" and ", clauses);
    }

    private Map<String, Object> cleanBody(Map<String, Object> body, boolean allowEmpty) {
        if ((body == null || body.isEmpty()) && !allowEmpty) {
            throw new BusinessException("提交内容不能为空");
        }
        Map<String, Object> data = new LinkedHashMap<>();
        if (body != null) {
            body.forEach((key, value) -> {
                if (key.matches("[a-zA-Z0-9_]+") && !"id".equals(key)) {
                    data.put(key, value);
                }
            });
        }
        if (data.isEmpty()) {
            throw new BusinessException("没有可保存的字段");
        }
        return data;
    }

    private void log(String action, String module) {
        AuthUser user = AuthContext.get();
        if (user != null) {
            jdbcTemplate.update("insert into operation_log(operator_name, module, action, content, created_at) values(?,?,?,?,?)",
                    user.realName(), module, action, user.realName() + action + module + "数据", LocalDateTime.now());
        }
    }
}
