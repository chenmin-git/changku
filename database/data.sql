use smart_warehouse;

insert into sys_role(id, code, name, remark) values
(1, 'ADMIN', '管理员', '拥有系统全部管理权限'),
(2, 'KEEPER', '仓管员', '负责库存、入库、出库和盘点业务');

insert into sys_user(id, username, password, real_name, role_id, phone, status, created_at) values
(1, 'admin', '123456', '系统管理员', 1, '13800000001', '启用', date_sub(now(), interval 180 day)),
(2, 'keeper', '123456', '仓库主管', 2, '13800000002', '启用', date_sub(now(), interval 120 day)),
(3, 'wms01', '123456', '一号仓管员', 2, '13800000003', '启用', date_sub(now(), interval 90 day)),
(4, 'wms02', '123456', '二号仓管员', 2, '13800000004', '启用', date_sub(now(), interval 60 day));

insert into warehouse(name, code, location, manager, capacity, status, remark, created_at) values
('华东一号仓', 'WH-HD-01', '上海市浦东新区', '仓库主管', 12000, '启用', '常温综合仓', date_sub(now(), interval 170 day)),
('华南周转仓', 'WH-HN-02', '广州市黄埔区', '一号仓管员', 8000, '启用', '快进快出周转仓', date_sub(now(), interval 145 day)),
('备件中心仓', 'WH-BJ-03', '苏州市工业园区', '二号仓管员', 6500, '启用', '备品备件专用仓', date_sub(now(), interval 100 day)),
('临期隔离仓', 'WH-LQ-04', '杭州市钱塘区', '仓库主管', 2400, '维护中', '异常品隔离区域', date_sub(now(), interval 75 day));

insert into goods_category(name, code, status, sort_no, remark, created_at) values
('电子元件', 'CAT-ELEC', '启用', 1, '常用电子配件', date_sub(now(), interval 175 day)),
('办公耗材', 'CAT-OFFICE', '启用', 2, '办公用品与打印耗材', date_sub(now(), interval 150 day)),
('包装材料', 'CAT-PACK', '启用', 3, '纸箱、胶带、缓冲材料', date_sub(now(), interval 120 day)),
('设备备件', 'CAT-PARTS', '启用', 4, '仓储设备维修备件', date_sub(now(), interval 95 day)),
('安全用品', 'CAT-SAFE', '启用', 5, '劳保与安全防护物资', date_sub(now(), interval 80 day));

insert into supplier(name, contact_name, phone, level, address, status, remark, created_at) values
('上海智联供应链有限公司', '张经理', '13910000001', 'A级', '上海市闵行区', '合作中', '交付稳定', date_sub(now(), interval 160 day)),
('苏州恒丰包装材料厂', '李主管', '13910000002', 'A级', '苏州市吴中区', '合作中', '包装材料主供', date_sub(now(), interval 140 day)),
('广州安盾劳保用品有限公司', '陈经理', '13910000003', 'B级', '广州市白云区', '合作中', '安全用品供应', date_sub(now(), interval 118 day)),
('杭州精密备件有限公司', '周工', '13910000004', 'B级', '杭州市滨江区', '合作中', '备件交期需跟踪', date_sub(now(), interval 86 day)),
('南京云仓贸易有限公司', '王经理', '13910000005', 'C级', '南京市江宁区', '暂停', '价格需复核', date_sub(now(), interval 66 day));

insert into customer(name, contact_name, phone, level, address, status, remark, created_at) values
('华东运营中心', '赵主管', '13710000001', '重点', '上海市浦东新区', '正常', '月度配送客户', date_sub(now(), interval 150 day)),
('南京分拨中心', '钱主管', '13710000002', '普通', '南京市雨花台区', '正常', '周度补货', date_sub(now(), interval 130 day)),
('杭州售后服务部', '孙主管', '13710000003', '重点', '杭州市上城区', '正常', '备件消耗较快', date_sub(now(), interval 100 day)),
('广州项目组', '李主管', '13710000004', '普通', '广州市天河区', '正常', '项目制领用', date_sub(now(), interval 80 day)),
('苏州研发中心', '郑主管', '13710000005', '普通', '苏州市工业园区', '正常', '研发耗材领用', date_sub(now(), interval 55 day));

insert into goods(name, code, category_id, specification, unit, image, stock_quantity, min_stock, max_stock, warehouse_id, status, remark, created_at) values
('扫码枪电池', 'G-2026-001', 1, '7.4V/2200mAh', '块', '/uploads/demo/battery.svg', 42, 50, 300, 1, '上架', '低于安全库存', date_sub(now(), interval 168 day)),
('热敏标签纸', 'G-2026-002', 2, '80mm*60mm', '卷', '/uploads/demo/label.svg', 860, 200, 2000, 1, '上架', '常用耗材', date_sub(now(), interval 155 day)),
('五层瓦楞纸箱', 'G-2026-003', 3, '500*400*300', '个', '/uploads/demo/box.svg', 1200, 300, 5000, 2, '上架', '包装主材', date_sub(now(), interval 149 day)),
('叉车轮胎', 'G-2026-004', 4, '28*9-15', '条', '/uploads/demo/tire.svg', 18, 20, 120, 3, '上架', '需补货', date_sub(now(), interval 132 day)),
('防割手套', 'G-2026-005', 5, 'L码', '双', '/uploads/demo/glove.svg', 260, 100, 1000, 2, '上架', '劳保用品', date_sub(now(), interval 120 day)),
('打印机碳带', 'G-2026-006', 2, '110mm*300m', '卷', '/uploads/demo/ribbon.svg', 76, 80, 600, 1, '上架', '接近下限', date_sub(now(), interval 96 day)),
('缓冲气泡膜', 'G-2026-007', 3, '60cm*100m', '卷', '/uploads/demo/film.svg', 340, 120, 1200, 2, '上架', '出库频繁', date_sub(now(), interval 80 day)),
('仓储货架横梁', 'G-2026-008', 4, '2.7m', '根', '/uploads/demo/beam.svg', 64, 30, 300, 3, '上架', '维修备件', date_sub(now(), interval 72 day)),
('RFID标签', 'G-2026-009', 1, 'UHF', '张', '/uploads/demo/rfid.svg', 5400, 1000, 10000, 1, '上架', '盘点使用', date_sub(now(), interval 60 day)),
('安全警示胶带', 'G-2026-010', 5, '黄黑 48mm', '卷', '/uploads/demo/tape.svg', 95, 120, 800, 4, '上架', '隔离仓需补货', date_sub(now(), interval 44 day));

insert into inbound_order(order_no, supplier_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('IN2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '上海智联供应链有限公司','苏州恒丰包装材料厂','广州安盾劳保用品有限公司','杭州精密备件有限公司','南京云仓贸易有限公司'),
       elt(1 + mod(n,10), '扫码枪电池','热敏标签纸','五层瓦楞纸箱','叉车轮胎','防割手套','打印机碳带','缓冲气泡膜','仓储货架横梁','RFID标签','安全警示胶带'),
       1 + mod(n,4),
       20 + mod(n * 13, 260),
       round((20 + mod(n * 13, 260)) * (8 + mod(n, 80)), 2),
       elt(1 + mod(n,4), '待审核','已入库','已驳回','已入库'),
       elt(1 + mod(n,3), '仓库主管','一号仓管员','二号仓管员'),
       '系统初始化演示入库单',
       date_sub(now(), interval (180 - n * 3) day)
from (
  select 1 n union all select 2 union all select 3 union all select 4 union all select 5 union all
  select 6 union all select 7 union all select 8 union all select 9 union all select 10 union all
  select 11 union all select 12 union all select 13 union all select 14 union all select 15 union all
  select 16 union all select 17 union all select 18 union all select 19 union all select 20 union all
  select 21 union all select 22 union all select 23 union all select 24 union all select 25 union all
  select 26 union all select 27 union all select 28 union all select 29 union all select 30
) nums;

insert into outbound_order(order_no, customer_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('OUT2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '华东运营中心','南京分拨中心','杭州售后服务部','广州项目组','苏州研发中心'),
       elt(1 + mod(n,10), '扫码枪电池','热敏标签纸','五层瓦楞纸箱','叉车轮胎','防割手套','打印机碳带','缓冲气泡膜','仓储货架横梁','RFID标签','安全警示胶带'),
       1 + mod(n,4),
       10 + mod(n * 9, 180),
       round((10 + mod(n * 9, 180)) * (10 + mod(n, 90)), 2),
       elt(1 + mod(n,4), '待出库','已出库','已取消','已出库'),
       elt(1 + mod(n,3), '仓库主管','一号仓管员','二号仓管员'),
       '系统初始化演示出库单',
       date_sub(now(), interval (170 - n * 3) day)
from (
  select 1 n union all select 2 union all select 3 union all select 4 union all select 5 union all
  select 6 union all select 7 union all select 8 union all select 9 union all select 10 union all
  select 11 union all select 12 union all select 13 union all select 14 union all select 15 union all
  select 16 union all select 17 union all select 18 union all select 19 union all select 20 union all
  select 21 union all select 22 union all select 23 union all select 24 union all select 25 union all
  select 26 union all select 27 union all select 28 union all select 29 union all select 30
) nums;

insert into stock_check(check_no, goods_name, warehouse_id, book_quantity, real_quantity, difference_quantity, status, operator_name, remark, created_at) values
('CHK2026001', '扫码枪电池', 1, 46, 42, -4, '待处理', '仓库主管', '低库存需复核', date_sub(now(), interval 32 day)),
('CHK2026002', '热敏标签纸', 1, 860, 858, -2, '已完成', '一号仓管员', '误差正常', date_sub(now(), interval 28 day)),
('CHK2026003', '叉车轮胎', 3, 20, 18, -2, '待处理', '二号仓管员', '需确认领用记录', date_sub(now(), interval 20 day)),
('CHK2026004', 'RFID标签', 1, 5400, 5410, 10, '已完成', '仓库主管', '盘盈入账', date_sub(now(), interval 12 day)),
('CHK2026005', '安全警示胶带', 4, 100, 95, -5, '待处理', '一号仓管员', '隔离仓领用未登记', date_sub(now(), interval 6 day));

insert into stock_alert(goods_name, alert_type, current_stock, min_stock, level, status, remark, created_at) values
('扫码枪电池', '低库存', 42, 50, '高', '待处理', '建议本周补货 120 块', date_sub(now(), interval 10 day)),
('叉车轮胎', '低库存', 18, 20, '高', '待处理', '设备维修备件不足', date_sub(now(), interval 8 day)),
('打印机碳带', '接近下限', 76, 80, '中', '待处理', '建议跟随标签纸一起采购', date_sub(now(), interval 5 day)),
('安全警示胶带', '低库存', 95, 120, '中', '待处理', '隔离仓消耗增加', date_sub(now(), interval 3 day)),
('RFID标签', '库存充足', 5400, 1000, '低', '已处理', '无需补货', date_sub(now(), interval 15 day));

insert into notice(title, content, status, publisher, created_at) values
('月度盘点安排', '请各仓库在本周五前完成重点货品盘点。', '已发布', '系统管理员', date_sub(now(), interval 14 day)),
('低库存处理提醒', '库存预警等级为高的数据需要优先处理并登记结果。', '已发布', '系统管理员', date_sub(now(), interval 9 day)),
('入库单审核规范', '入库单需核对供应商、数量、金额和仓库信息。', '草稿', '系统管理员', date_sub(now(), interval 4 day));

insert into operation_log(operator_name, module, action, content, created_at) values
('系统管理员', '用户', '登录', '管理员登录系统', date_sub(now(), interval 2 day)),
('仓库主管', '入库单', '审核', '审核入库单 IN2026008', date_sub(now(), interval 1 day)),
('一号仓管员', '库存预警', '处理', '处理热敏标签纸预警', date_sub(now(), interval 12 hour)),
('二号仓管员', '盘点', '新增', '新增叉车轮胎盘点记录', date_sub(now(), interval 3 hour));
