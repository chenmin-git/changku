package com.example.warehouse.service;

import java.util.List;
import java.util.Map;

public final class ModuleRegistry {
    private ModuleRegistry() {
    }

    public record ModuleMeta(String table, String label, List<String> searchable, List<String> filterable, boolean adminOnly) {
    }

    private static final Map<String, ModuleMeta> MODULES = Map.ofEntries(
            Map.entry("users", new ModuleMeta("sys_user", "用户", List.of("username", "real_name", "phone"), List.of("status", "role_id"), true)),
            Map.entry("warehouses", new ModuleMeta("warehouse", "仓库", List.of("name", "manager", "location"), List.of("status"), true)),
            Map.entry("categories", new ModuleMeta("goods_category", "货品分类", List.of("name", "code"), List.of("status"), true)),
            Map.entry("goods", new ModuleMeta("goods", "货品", List.of("name", "code", "specification"), List.of("category_id", "status"), false)),
            Map.entry("suppliers", new ModuleMeta("supplier", "供应商", List.of("name", "contact_name", "phone"), List.of("level", "status"), true)),
            Map.entry("customers", new ModuleMeta("customer", "客户", List.of("name", "contact_name", "phone"), List.of("level", "status"), true)),
            Map.entry("inbounds", new ModuleMeta("inbound_order", "入库单", List.of("order_no", "supplier_name", "goods_name"), List.of("status", "warehouse_id"), false)),
            Map.entry("outbounds", new ModuleMeta("outbound_order", "出库单", List.of("order_no", "customer_name", "goods_name"), List.of("status", "warehouse_id"), false)),
            Map.entry("checks", new ModuleMeta("stock_check", "库存盘点", List.of("check_no", "goods_name", "operator_name"), List.of("status", "warehouse_id"), false)),
            Map.entry("alerts", new ModuleMeta("stock_alert", "库存预警", List.of("goods_name", "alert_type"), List.of("level", "status"), false)),
            Map.entry("notices", new ModuleMeta("notice", "公告", List.of("title", "content"), List.of("status"), true)),
            Map.entry("logs", new ModuleMeta("operation_log", "操作日志", List.of("operator_name", "action", "module"), List.of("module"), true))
    );

    public static ModuleMeta get(String module) {
        ModuleMeta meta = MODULES.get(module);
        if (meta == null) {
            throw new IllegalArgumentException("未知模块：" + module);
        }
        return meta;
    }

    public static Map<String, ModuleMeta> all() {
        return MODULES;
    }
}
