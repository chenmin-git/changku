package com.example.warehouse.service;

import com.example.warehouse.config.AuthContext;
import com.example.warehouse.dto.AuthUser;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class DashboardService {
    private final JdbcTemplate jdbcTemplate;

    public DashboardService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> summary() {
        AuthUser user = AuthContext.get();
        boolean admin = user != null && "ADMIN".equals(user.roleCode());
        return Map.of(
                "role", admin ? "管理员" : "仓管员",
                "cards", List.of(
                        card("货品总数", count("goods"), "种"),
                        card("待处理预警", count("stock_alert where status = '待处理'"), "条"),
                        card("本月入库", count("inbound_order where created_at >= date_format(now(), '%Y-%m-01')"), "单"),
                        card(admin ? "系统用户" : "待盘点", admin ? count("sys_user") : count("stock_check where status = '待处理'"), admin ? "人" : "项")
                ),
                "trend", monthTrend(),
                "weekTrend", weekTrend(),
                "categoryStock", categoryStock(),
                "todo", todo(admin),
                "quickTodos", quickTodos(),
                "riskTop", riskTop(),
                "recent", recentLogs()
        );
    }

    private List<Map<String, Object>> monthTrend() {
        return jdbcTemplate.queryForList("""
                select date_format(created_at, '%Y-%m') as month,
                       sum(case when source = 'in' then quantity else 0 end) as inbound,
                       sum(case when source = 'out' then quantity else 0 end) as outbound
                from (
                  select created_at, quantity, 'in' as source from inbound_order
                  union all
                  select created_at, quantity, 'out' as source from outbound_order
                ) t
                group by date_format(created_at, '%Y-%m')
                order by month desc
                limit 6
                """);
    }

    private List<Map<String, Object>> weekTrend() {
        return jdbcTemplate.queryForList("""
                select date_format(days.d, '%m-%d') as day,
                       coalesce(sum(case when t.source = 'in' then t.quantity else 0 end), 0) as inbound,
                       coalesce(sum(case when t.source = 'out' then t.quantity else 0 end), 0) as outbound
                from (
                  select curdate() - interval 6 day as d
                  union all select curdate() - interval 5 day
                  union all select curdate() - interval 4 day
                  union all select curdate() - interval 3 day
                  union all select curdate() - interval 2 day
                  union all select curdate() - interval 1 day
                  union all select curdate()
                ) days
                left join (
                  select created_at, quantity, 'in' as source from inbound_order
                  union all
                  select created_at, quantity, 'out' as source from outbound_order
                ) t on date(t.created_at) = days.d
                group by days.d
                order by days.d
                """);
    }

    private List<Map<String, Object>> categoryStock() {
        return jdbcTemplate.queryForList("""
                select coalesce(c.name, '未分类') as name, sum(g.stock_quantity) as value
                from goods g
                left join goods_category c on c.id = g.category_id
                group by c.name
                order by value desc
                """);
    }

    private List<Map<String, Object>> todo(boolean admin) {
        if (admin) {
            return jdbcTemplate.queryForList("""
                    select title, status, created_at, path, type
                    from (
                      select concat('入库单待审核：', order_no) as title, status, created_at, '/inbounds' as path, '入库审核' as type from inbound_order where status = '待审核'
                      union all
                      select concat('出库单待处理：', order_no) as title, status, created_at, '/outbounds' as path, '出库处理' as type from outbound_order where status = '待出库'
                      union all
                      select concat('库存预警：', goods_name) as title, level as status, created_at, '/alerts' as path, '库存预警' as type from stock_alert where status = '待处理'
                      union all
                      select concat('盘点待处理：', check_no) as title, status, created_at, '/checks' as path, '库存盘点' as type from stock_check where status = '待处理'
                    ) t
                    order by created_at desc
                    limit 8
                    """);
        }
        return jdbcTemplate.queryForList("""
                select title, status, created_at, path, type
                from (
                  select concat('出库单待处理：', order_no) as title, status, created_at, '/outbounds' as path, '出库处理' as type from outbound_order where status = '待出库'
                  union all
                  select concat('库存预警：', goods_name) as title, level as status, created_at, '/alerts' as path, '库存预警' as type from stock_alert where status = '待处理'
                  union all
                  select concat('盘点待处理：', check_no) as title, status, created_at, '/checks' as path, '库存盘点' as type from stock_check where status = '待处理'
                ) t
                order by created_at desc
                limit 8
                """);
    }

    private List<Map<String, Object>> quickTodos() {
        return List.of(
                quickTodo("待审核入库", count("inbound_order where status = '待审核'"), "/inbounds", "Bottom"),
                quickTodo("待出库单", count("outbound_order where status = '待出库'"), "/outbounds", "Top"),
                quickTodo("待处理预警", count("stock_alert where status = '待处理'"), "/alerts", "Warning"),
                quickTodo("待处理盘点", count("stock_check where status = '待处理'"), "/checks", "Checked")
        );
    }

    private List<Map<String, Object>> riskTop() {
        return jdbcTemplate.queryForList("""
                select g.name,
                       g.stock_quantity as current_stock,
                       g.min_stock,
                       w.name as warehouse_name,
                       case
                         when g.stock_quantity <= g.min_stock then '高'
                         when g.stock_quantity <= g.min_stock + 20 then '中'
                         else '低'
                       end as level,
                       concat('建议补货 ', greatest(g.max_stock - g.stock_quantity, 0), ' ', g.unit) as suggestion
                from goods g
                left join warehouse w on w.id = g.warehouse_id
                order by (g.stock_quantity - g.min_stock) asc, g.id desc
                limit 5
                """);
    }

    private List<Map<String, Object>> recentLogs() {
        return jdbcTemplate.queryForList("""
                select operator_name, module, action, content, created_at
                from operation_log
                order by id desc
                limit 8
                """);
    }

    private Map<String, Object> card(String title, long value, String unit) {
        return Map.of("title", title, "value", value, "unit", unit);
    }

    private Map<String, Object> quickTodo(String title, long value, String path, String icon) {
        return Map.of("title", title, "value", value, "path", path, "icon", icon);
    }

    private long count(String expression) {
        Long value = jdbcTemplate.queryForObject("select count(*) from " + expression, Long.class);
        return value == null ? 0 : value;
    }
}
