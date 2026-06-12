use smart_warehouse;

insert into goods(name, code, category_id, specification, unit, image, stock_quantity, min_stock, max_stock, warehouse_id, status, remark, created_at) values
('无线扫码枪', 'G-2026-011', 1, '2.4G/USB', '把', '/uploads/demo/scanner.png', 32, 20, 180, 1, '上架', '分拣区常用设备', date_sub(now(), interval 38 day)),
('标准木托盘', 'G-2026-012', 3, '1200*1000mm', '个', '/uploads/demo/pallet.png', 260, 80, 900, 2, '上架', '整托入库使用', date_sub(now(), interval 36 day)),
('安全头盔', 'G-2026-013', 5, '黄色/可调节', '顶', '/uploads/demo/helmet.png', 84, 60, 500, 4, '上架', '访客与作业人员领用', date_sub(now(), interval 34 day)),
('反光背心', 'G-2026-014', 5, '均码', '件', '/uploads/demo/vest.png', 118, 80, 600, 4, '上架', '夜间作业用品', date_sub(now(), interval 33 day)),
('封箱胶带', 'G-2026-015', 3, '60mm*100m', '卷', '/uploads/demo/seal.png', 430, 160, 1600, 2, '上架', '包装线消耗品', date_sub(now(), interval 32 day)),
('周转小车', 'G-2026-016', 4, '三层静音轮', '台', '/uploads/demo/cart.png', 22, 12, 100, 3, '上架', '库内拣货周转', date_sub(now(), interval 30 day)),
('温湿度传感器', 'G-2026-017', 1, 'LoRa/电池款', '个', '/uploads/demo/sensor.png', 46, 30, 240, 1, '上架', '库区环境监测', date_sub(now(), interval 28 day)),
('仓库网关', 'G-2026-018', 1, '4G/WiFi', '台', '/uploads/demo/router.png', 16, 10, 80, 1, '上架', '物联设备接入', date_sub(now(), interval 27 day)),
('数据线缆', 'G-2026-019', 1, 'Type-C 1.5m', '根', '/uploads/demo/cable.png', 520, 180, 1800, 1, '上架', '设备维护备用', date_sub(now(), interval 25 day)),
('防震垫片', 'G-2026-020', 4, '橡胶 80mm', '片', '/uploads/demo/pad.png', 760, 240, 2200, 3, '上架', '设备安装辅材', date_sub(now(), interval 24 day)),
('输送线电机', 'G-2026-021', 4, '1.5kW', '台', '/uploads/demo/motor.png', 9, 12, 60, 3, '上架', '低于安全库存', date_sub(now(), interval 22 day)),
('工业交换机', 'G-2026-022', 1, '8口千兆', '台', '/uploads/demo/switch.png', 24, 16, 120, 1, '上架', '网络备件', date_sub(now(), interval 21 day)),
('防尘口罩', 'G-2026-023', 5, 'KN95', '盒', '/uploads/demo/mask.png', 150, 120, 1000, 4, '上架', '粉尘区备用', date_sub(now(), interval 18 day)),
('应急照明灯', 'G-2026-024', 4, '双头 LED', '盏', '/uploads/demo/lamp.png', 36, 24, 160, 3, '上架', '安全巡检用品', date_sub(now(), interval 16 day)),
('库门锁具', 'G-2026-025', 4, '电子锁', '套', '/uploads/demo/lock.png', 14, 10, 80, 3, '上架', '库门维护备件', date_sub(now(), interval 15 day)),
('分拣料盒', 'G-2026-026', 3, '蓝色 400*300', '个', '/uploads/demo/tray.png', 640, 180, 1800, 2, '上架', '分拣台容器', date_sub(now(), interval 12 day)),
('电子台秤', 'G-2026-027', 4, '150kg', '台', '/uploads/demo/scale.png', 12, 8, 60, 3, '上架', '称重复核设备', date_sub(now(), interval 10 day)),
('充电底座', 'G-2026-028', 1, '扫码枪配套', '个', '/uploads/demo/charger.png', 28, 20, 160, 1, '上架', '扫码枪配件', date_sub(now(), interval 8 day)),
('货架标签', 'G-2026-029', 2, '90*40mm', '张', '/uploads/demo/shelf-tag.png', 3200, 800, 8000, 1, '上架', '库位标识', date_sub(now(), interval 6 day)),
('拉伸缠绕膜', 'G-2026-030', '3', '50cm*300m', '卷', '/uploads/demo/wrap.png', 210, 120, 900, 2, '上架', '整托包装耗材', date_sub(now(), interval 4 day));

insert into supplier(name, contact_name, phone, level, address, status, remark, created_at) values
('无锡迅捷设备有限公司', '刘经理', '13910000006', 'A级', '无锡市新吴区', '合作中', '扫码设备与配件', date_sub(now(), interval 50 day)),
('常州安航安全用品厂', '何主管', '13910000007', 'B级', '常州市武进区', '合作中', '安全用品补充供应商', date_sub(now(), interval 48 day)),
('宁波托盘包装有限公司', '许经理', '13910000008', 'A级', '宁波市北仑区', '合作中', '托盘与包装材料', date_sub(now(), interval 46 day)),
('合肥智控物联科技', '马工', '13910000009', 'B级', '合肥市高新区', '合作中', '传感器与网关', date_sub(now(), interval 42 day)),
('武汉仓储备件中心', '郭经理', '13910000010', 'B级', '武汉市东西湖区', '合作中', '输送线与库门备件', date_sub(now(), interval 39 day));

insert into customer(name, contact_name, phone, level, address, status, remark, created_at) values
('成都分拨中心', '蒋主管', '13710000006', '重点', '成都市龙泉驿区', '正常', '西南区域分拨', date_sub(now(), interval 52 day)),
('重庆售后站', '唐主管', '13710000007', '普通', '重庆市渝北区', '正常', '售后备件领用', date_sub(now(), interval 49 day)),
('合肥运营仓', '丁主管', '13710000008', '普通', '合肥市包河区', '正常', '区域补货', date_sub(now(), interval 45 day)),
('武汉项目仓', '袁主管', '13710000009', '重点', '武汉市江夏区', '正常', '项目制领用', date_sub(now(), interval 43 day)),
('厦门前置仓', '林主管', '13710000010', '普通', '厦门市集美区', '正常', '前置库存补充', date_sub(now(), interval 40 day));

insert into stock_alert(goods_name, alert_type, current_stock, min_stock, level, status, remark, created_at) values
('输送线电机', '低库存', 9, 12, '高', '待处理', '建议立即补货 20 台', date_sub(now(), interval 2 day)),
('叉车轮胎', '低库存', 18, 20, '高', '待处理', '维修季消耗较快', date_sub(now(), interval 2 day)),
('扫码枪电池', '低库存', 42, 50, '高', '待处理', '一线设备备用不足', date_sub(now(), interval 1 day)),
('打印机碳带', '接近下限', 76, 80, '中', '待处理', '建议随标签纸合并采购', date_sub(now(), interval 1 day)),
('拉伸缠绕膜', '接近下限', 210, 120, '低', '已处理', '暂不需要补货', date_sub(now(), interval 3 day));

insert into stock_check(check_no, goods_name, warehouse_id, book_quantity, real_quantity, difference_quantity, status, operator_name, remark, created_at) values
('CHK2026006', '输送线电机', 3, 10, 9, -1, '待处理', '二号仓管员', '维修领用待补登记', date_sub(now(), interval 3 day)),
('CHK2026007', '标准木托盘', 2, 260, 260, 0, '已完成', '一号仓管员', '账实一致', date_sub(now(), interval 2 day)),
('CHK2026008', '货架标签', 1, 3200, 3188, -12, '待处理', '仓库主管', '分拣区消耗差异', date_sub(now(), interval 1 day));

insert into inbound_order(order_no, supplier_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('INX2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '无锡迅捷设备有限公司','常州安航安全用品厂','宁波托盘包装有限公司','合肥智控物联科技','武汉仓储备件中心'),
       elt(1 + mod(n,20), '无线扫码枪','标准木托盘','安全头盔','反光背心','封箱胶带','周转小车','温湿度传感器','仓库网关','数据线缆','防震垫片','输送线电机','工业交换机','防尘口罩','应急照明灯','库门锁具','分拣料盒','电子台秤','充电底座','货架标签','拉伸缠绕膜'),
       1 + mod(n,4),
       15 + mod(n * 11, 220),
       round((15 + mod(n * 11, 220)) * (12 + mod(n, 75)), 2),
       elt(1 + mod(n,4), '待审核','已入库','已驳回','已入库'),
       elt(1 + mod(n,3), '仓库主管','一号仓管员','二号仓管员'),
       '扩展演示入库单',
       date_sub(now(), interval (120 - n * 2) day)
from (
  select 1 n union all select 2 union all select 3 union all select 4 union all select 5 union all
  select 6 union all select 7 union all select 8 union all select 9 union all select 10 union all
  select 11 union all select 12 union all select 13 union all select 14 union all select 15 union all
  select 16 union all select 17 union all select 18 union all select 19 union all select 20 union all
  select 21 union all select 22 union all select 23 union all select 24 union all select 25 union all
  select 26 union all select 27 union all select 28 union all select 29 union all select 30 union all
  select 31 union all select 32 union all select 33 union all select 34 union all select 35 union all
  select 36 union all select 37 union all select 38 union all select 39 union all select 40
) nums;

insert into outbound_order(order_no, customer_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('OUTX2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '成都分拨中心','重庆售后站','合肥运营仓','武汉项目仓','厦门前置仓'),
       elt(1 + mod(n,20), '无线扫码枪','标准木托盘','安全头盔','反光背心','封箱胶带','周转小车','温湿度传感器','仓库网关','数据线缆','防震垫片','输送线电机','工业交换机','防尘口罩','应急照明灯','库门锁具','分拣料盒','电子台秤','充电底座','货架标签','拉伸缠绕膜'),
       1 + mod(n,4),
       8 + mod(n * 7, 160),
       round((8 + mod(n * 7, 160)) * (15 + mod(n, 60)), 2),
       elt(1 + mod(n,4), '待出库','已出库','已取消','已出库'),
       elt(1 + mod(n,3), '仓库主管','一号仓管员','二号仓管员'),
       '扩展演示出库单',
       date_sub(now(), interval (110 - n * 2) day)
from (
  select 1 n union all select 2 union all select 3 union all select 4 union all select 5 union all
  select 6 union all select 7 union all select 8 union all select 9 union all select 10 union all
  select 11 union all select 12 union all select 13 union all select 14 union all select 15 union all
  select 16 union all select 17 union all select 18 union all select 19 union all select 20 union all
  select 21 union all select 22 union all select 23 union all select 24 union all select 25 union all
  select 26 union all select 27 union all select 28 union all select 29 union all select 30 union all
  select 31 union all select 32 union all select 33 union all select 34 union all select 35 union all
  select 36 union all select 37 union all select 38 union all select 39 union all select 40
) nums;
