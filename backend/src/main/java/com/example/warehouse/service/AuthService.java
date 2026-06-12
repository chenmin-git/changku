package com.example.warehouse.service;

import com.example.warehouse.common.BusinessException;
import com.example.warehouse.dto.AuthUser;
import com.example.warehouse.dto.LoginRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class AuthService {
    private final JdbcTemplate jdbcTemplate;
    private final Map<String, AuthUser> sessions = new ConcurrentHashMap<>();

    public AuthService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> login(LoginRequest request) {
        String sql = """
                select u.id, u.username, u.real_name, r.code as role_code, r.name as role_name
                from sys_user u
                join sys_role r on r.id = u.role_id
                where u.username = ? and u.password = ? and u.status = '启用'
                """;
        var users = jdbcTemplate.query(sql, (rs, rowNum) -> new AuthUser(
                rs.getLong("id"),
                rs.getString("username"),
                rs.getString("real_name"),
                rs.getString("role_code"),
                rs.getString("role_name")
        ), request.username(), request.password());
        if (users.isEmpty()) {
            throw new BusinessException("账号或密码错误，或账号已被禁用");
        }
        AuthUser user = users.getFirst();
        String token = UUID.randomUUID().toString().replace("-", "");
        sessions.put(token, user);
        jdbcTemplate.update("update sys_user set last_login_time = ? where id = ?", LocalDateTime.now(), user.id());
        return Map.of("token", token, "user", user);
    }

    public Optional<AuthUser> findByToken(String token) {
        if (token == null || token.isBlank()) {
            return Optional.empty();
        }
        return Optional.ofNullable(sessions.get(token));
    }

    public void requireAdmin(AuthUser user) {
        if (user == null || !"ADMIN".equals(user.roleCode())) {
            throw new BusinessException("当前账号无管理员权限");
        }
    }
}
