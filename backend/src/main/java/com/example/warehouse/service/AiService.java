package com.example.warehouse.service;

import com.example.warehouse.config.SparkProperties;
import com.example.warehouse.dto.AiRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class AiService {
    private final SparkProperties properties;
    private final JdbcTemplate jdbcTemplate;
    private final RestClient restClient = RestClient.create();

    public AiService(SparkProperties properties, JdbcTemplate jdbcTemplate) {
        this.properties = properties;
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> ask(AiRequest request) {
        String question = normalizeQuestion(request);
        Map<String, Object> context = buildWarehouseContext();
        String answer = callRemoteAi(question, context.toString());
        String provider = "系统默认 AI 服务";
        String notice = "";
        if (answer == null || answer.isBlank()) {
            answer = fallbackAnswer(question, context);
            provider = "本地智能分析";
            notice = properties.getApiKey() == null || properties.getApiKey().isBlank()
                    ? "未配置外部 AI 密钥，已使用本地库存分析结果。"
                    : "外部 AI 服务暂不可用，已使用本地库存分析结果。";
        }
        return Map.of(
                "answer", answer,
                "provider", provider,
                "notice", notice,
                "context", context,
                "suggestions", suggestions()
        );
    }

    public String buildStreamingAnswer(AiRequest request) {
        return ask(request).get("answer").toString();
    }

    public Map<String, Object> contextPayload() {
        return Map.of(
                "provider", properties.getApiKey() == null || properties.getApiKey().isBlank() ? "本地智能分析" : "系统默认 AI 服务",
                "context", buildWarehouseContext(),
                "suggestions", suggestions()
        );
    }

    private String normalizeQuestion(AiRequest request) {
        return request.question() == null || request.question().isBlank()
                ? "请根据当前仓库数据生成补货、预警、盘点和待办处理建议"
                : request.question();
    }

    private List<String> suggestions() {
        return List.of(
                "生成补货计划",
                "分析高风险库存预警",
                "总结近 7 天入出库趋势",
                "生成盘点任务清单",
                "按仓库给出补货建议",
                "解释当前待办优先级"
        );
    }

    private String callRemoteAi(String question, String contextText) {
        if (properties.getApiKey() == null || properties.getApiKey().isBlank()) {
            return null;
        }
        Map<String, Object> payload = Map.of(
                "model", properties.getModel(),
                "messages", List.of(
                        Map.of("role", "system", "content", "你是智能仓库管理系统的库存助手。请基于系统给出的真实业务数据，用中文输出简洁、可执行、适合仓库管理答辩演示的建议。回答可以使用 Markdown，但不要输出代码块，不要泄露接口、密钥或供应商信息。"),
                        Map.of("role", "user", "content", "系统业务上下文：" + contextText + "\n用户问题：" + question)
                )
        );
        try {
            Map<?, ?> response = restClient.post()
                    .uri(properties.getBaseUrl())
                    .header(HttpHeaders.AUTHORIZATION, "Bearer " + properties.getApiKey())
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(payload)
                    .retrieve()
                    .body(Map.class);
            Object answer = extractAnswer(response);
            return answer == null ? null : answer.toString();
        } catch (Exception ex) {
            return null;
        }
    }

    private Map<String, Object> buildWarehouseContext() {
        List<Map<String, Object>> alerts = jdbcTemplate.queryForList("""
                select goods_name, alert_type, current_stock, min_stock, level, status, remark
                from stock_alert
                where status = '待处理'
                order by field(level, '高', '中', '低'), id desc
                limit 10
                """);
        List<Map<String, Object>> lowGoods = jdbcTemplate.queryForList("""
                select g.name, g.stock_quantity, g.min_stock, g.max_stock, w.name as warehouse_name,
                       greatest(g.max_stock - g.stock_quantity, 0) as suggest_quantity
                from goods g
                left join warehouse w on w.id = g.warehouse_id
                order by (g.stock_quantity - g.min_stock) asc
                limit 10
                """);
        List<Map<String, Object>> weekTrend = jdbcTemplate.queryForList("""
                with recursive days(d) as (
                  select curdate() - interval 6 day
                  union all
                  select d + interval 1 day from days where d < curdate()
                )
                select date_format(days.d, '%m-%d') as day,
                       coalesce(sum(case when t.source = 'in' then t.quantity else 0 end), 0) as inbound,
                       coalesce(sum(case when t.source = 'out' then t.quantity else 0 end), 0) as outbound
                from days
                left join (
                  select created_at, quantity, 'in' as source from inbound_order
                  union all
                  select created_at, quantity, 'out' as source from outbound_order
                ) t on date(t.created_at) = days.d
                group by days.d
                order by days.d
                """);
        List<Map<String, Object>> warehouseStock = jdbcTemplate.queryForList("""
                select w.name as warehouse_name, count(g.id) as goods_count, coalesce(sum(g.stock_quantity), 0) as total_stock
                from warehouse w
                left join goods g on g.warehouse_id = w.id
                group by w.id, w.name
                order by w.id
                """);
        List<Map<String, Object>> pendingTodos = jdbcTemplate.queryForList("""
                select title, value, path
                from (
                  select '待审核入库' as title, count(*) as value, '/inbounds' as path from inbound_order where status = '待审核'
                  union all select '待出库单', count(*), '/outbounds' from outbound_order where status = '待出库'
                  union all select '待处理预警', count(*), '/alerts' from stock_alert where status = '待处理'
                  union all select '待处理盘点', count(*), '/checks' from stock_check where status = '待处理'
                ) t
                """);
        return Map.of(
                "cards", pendingTodos,
                "alerts", alerts,
                "lowGoods", lowGoods,
                "weekTrend", weekTrend,
                "warehouseStock", warehouseStock,
                "pendingTodos", pendingTodos
        );
    }

    private String fallbackAnswer(String question, Map<String, Object> context) {
        String lower = question.toLowerCase();
        if (question.contains("补货")) {
            return replenishmentAnswer(question, context);
        }
        if (question.contains("7") || question.contains("趋势") || lower.contains("trend")) {
            return trendAnswer(question, context);
        }
        if (question.contains("盘点")) {
            return checkAnswer(question, context);
        }
        if (question.contains("待办")) {
            return todoAnswer(question, context);
        }
        if (question.contains("仓库")) {
            return warehouseAnswer(question, context);
        }
        if (question.contains("预警") || question.contains("高风险")) {
            return riskAnswer(question, context);
        }
        return replenishmentAnswer(question, context);
    }

    private String replenishmentAnswer(String question, Map<String, Object> context) {
        return """
                ## 补货计划建议
                1. **优先补低于安全下限的货品**：按库存缺口从大到小处理，先保证出库和安全生产不断供。
                2. **建议补到库存上限附近**：避免补货后很快再次触发预警。
                3. **先审核关联入库单**：如果低库存货品已有待审核入库，应先完成入库审核，再判断是否追加采购。
                4. **预留出库缓冲**：近 7 天出库量较高的货品，可额外预留 10%-20% 安全库存。

                ### 优先补货清单
                %s
                """.formatted(formatLowGoods(context, 5));
    }

    private String riskAnswer(String question, Map<String, Object> context) {
        return """
                ## 高风险库存分析
                - **高等级预警优先处理**：当前待处理预警应按“高、中、低”排序，先处理库存低于安全下限的货品。
                - **同步核对盘点差异**：如果预警货品近期也出现在盘点单中，需要先确认账实是否一致，避免按错误库存补货。
                - **联动出库单**：对待出库单中涉及的低库存货品，应先确认库存是否足够，再执行出库。
                - **形成闭环**：处理后在库存预警模块标记“已处理”，便于答辩时展示业务闭环和操作日志。

                ### 当前重点预警
                %s
                """.formatted(formatAlerts(context, 5));
    }

    private String trendAnswer(String question, Map<String, Object> context) {
        return """
                ## 近 7 天入出库趋势解读
                - 若连续多天出库量高于入库量，说明库存消耗压力上升，应提前生成补货计划。
                - 若入库量突然升高，需要关注是否存在集中到货、重复入库或仓库容量压力。
                - 若出入库都偏低，可安排盘点、库位整理和低频物资清理。
                - 建议在工作台结合“近 7 天入出库趋势”和“高风险库存 TOP5”一起讲解，更容易体现系统的数据分析能力。

                ### 近 7 天数据概览
                %s
                """.formatted(formatWeekTrend(context));
    }

    private String checkAnswer(String question, Map<String, Object> context) {
        return """
                ## 盘点任务清单建议
                1. **第一批**：库存低于安全下限、且存在待处理预警的货品。
                2. **第二批**：近 7 天出库频繁、库存接近下限的货品。
                3. **第三批**：账面库存较高但长期无出入库记录的货品，重点排查呆滞库存。
                4. **处理方式**：盘点完成后更新盘点状态，并将差异较大的货品同步记录到备注中。

                这样答辩时可以体现“预警 -> 盘点 -> 调整 -> 记录”的业务链路。
                """;
    }

    private String todoAnswer(String question, Map<String, Object> context) {
        return """
                ## 待办优先级说明
                1. **库存预警优先**：直接影响缺货风险，尤其是高等级预警。
                2. **待出库单其次**：影响客户交付，应核对库存后尽快处理。
                3. **待审核入库单**：影响补货入账，建议与预警货品联动处理。
                4. **待处理盘点**：用于校准库存准确性，建议安排在出入库低峰期。

                ### 当前待办概览
                %s
                """.formatted(formatTodos(context));
    }

    private String warehouseAnswer(String question, Map<String, Object> context) {
        return """
                ## 按仓库补货建议
                - 对总库存较低且低库存货品集中的仓库，优先安排补货或跨仓调拨。
                - 对总库存较高但仍有预警的仓库，重点检查库位分布和货品结构，避免“总量够、单品缺”。
                - 对冷链、设备、包装等不同仓库，应按业务属性设置不同安全库存阈值。

                ### 仓库库存概览
                %s
                """.formatted(formatWarehouseStock(context));
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> listContext(Map<String, Object> context, String key) {
        Object value = context.get(key);
        if (value instanceof List<?> list) {
            return list.stream()
                    .filter(Map.class::isInstance)
                    .map(item -> (Map<String, Object>) item)
                    .toList();
        }
        return List.of();
    }

    private String formatLowGoods(Map<String, Object> context, int limit) {
        List<Map<String, Object>> rows = listContext(context, "lowGoods");
        if (rows.isEmpty()) {
            return "- 暂无低库存货品。";
        }
        return rows.stream().limit(limit).map(row -> "- **%s**：当前库存 %s，安全下限 %s，建议补货 %s，所在仓库：%s。".formatted(
                text(row.get("name")),
                text(row.get("stock_quantity")),
                text(row.get("min_stock")),
                text(row.get("suggest_quantity")),
                text(row.get("warehouse_name"))
        )).collect(Collectors.joining("\n"));
    }

    private String formatAlerts(Map<String, Object> context, int limit) {
        List<Map<String, Object>> rows = listContext(context, "alerts");
        if (rows.isEmpty()) {
            return "- 暂无待处理预警。";
        }
        return rows.stream().limit(limit).map(row -> "- **%s**：%s预警，当前库存 %s，安全下限 %s，等级 %s。".formatted(
                text(row.get("goods_name")),
                text(row.get("alert_type")),
                text(row.get("current_stock")),
                text(row.get("min_stock")),
                text(row.get("level"))
        )).collect(Collectors.joining("\n"));
    }

    private String formatWeekTrend(Map<String, Object> context) {
        List<Map<String, Object>> rows = listContext(context, "weekTrend");
        if (rows.isEmpty()) {
            return "- 暂无近 7 天出入库数据。";
        }
        return rows.stream().map(row -> "- %s：入库 %s，出库 %s。".formatted(
                text(row.get("day")),
                text(row.get("inbound")),
                text(row.get("outbound"))
        )).collect(Collectors.joining("\n"));
    }

    private String formatTodos(Map<String, Object> context) {
        List<Map<String, Object>> rows = listContext(context, "pendingTodos");
        if (rows.isEmpty()) {
            return "- 暂无待处理事项。";
        }
        return rows.stream().map(row -> "- **%s**：%s 项，入口：%s。".formatted(
                text(row.get("title")),
                text(row.get("value")),
                text(row.get("path"))
        )).collect(Collectors.joining("\n"));
    }

    private String formatWarehouseStock(Map<String, Object> context) {
        List<Map<String, Object>> rows = listContext(context, "warehouseStock");
        if (rows.isEmpty()) {
            return "- 暂无仓库库存概览。";
        }
        return rows.stream().map(row -> "- **%s**：货品 %s 种，总库存 %s。".formatted(
                text(row.get("warehouse_name")),
                text(row.get("goods_count")),
                text(row.get("total_stock"))
        )).collect(Collectors.joining("\n"));
    }

    private String text(Object value) {
        return Objects.toString(value, "-");
    }

    private Object extractAnswer(Map<?, ?> response) {
        if (response == null) {
            return null;
        }
        Object choices = response.get("choices");
        if (choices instanceof List<?> list && !list.isEmpty() && list.getFirst() instanceof Map<?, ?> choice) {
            Object message = choice.get("message");
            if (message instanceof Map<?, ?> msg) {
                return msg.get("content");
            }
        }
        return null;
    }
}
