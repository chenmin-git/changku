-- Smart Warehouse Management System
-- Complete MySQL initialization script (UTF-8)
-- This script recreates all tables and imports demo data.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- Database schema
-- -----------------------------------------------------------------------------
create database if not exists smart_warehouse default character set utf8mb4 collate utf8mb4_unicode_ci;
use smart_warehouse;

drop table if exists operation_log;
drop table if exists stock_alert;
drop table if exists stock_check;
drop table if exists outbound_order;
drop table if exists inbound_order;
drop table if exists customer;
drop table if exists supplier;
drop table if exists goods;
drop table if exists goods_category;
drop table if exists warehouse;
drop table if exists notice;
drop table if exists sys_user;
drop table if exists sys_role;

create table sys_role (
  id bigint primary key auto_increment,
  code varchar(32) not null unique,
  name varchar(64) not null,
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table sys_user (
  id bigint primary key auto_increment,
  username varchar(64) not null unique,
  password varchar(128) not null,
  real_name varchar(64) not null,
  role_id bigint not null,
  phone varchar(32),
  avatar varchar(255),
  status varchar(16) default '启用',
  last_login_time datetime,
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table warehouse (
  id bigint primary key auto_increment,
  name varchar(100) not null,
  code varchar(64) not null,
  location varchar(255),
  manager varchar(64),
  capacity decimal(12,2) default 0,
  status varchar(16) default '启用',
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table goods_category (
  id bigint primary key auto_increment,
  name varchar(100) not null,
  code varchar(64) not null,
  status varchar(16) default '启用',
  sort_no int default 0,
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table goods (
  id bigint primary key auto_increment,
  name varchar(120) not null,
  code varchar(64) not null,
  category_id bigint,
  specification varchar(120),
  unit varchar(20) default '件',
  image varchar(255),
  stock_quantity int default 0,
  min_stock int default 0,
  max_stock int default 0,
  warehouse_id bigint,
  status varchar(16) default '上架',
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table supplier (
  id bigint primary key auto_increment,
  name varchar(120) not null,
  contact_name varchar(64),
  phone varchar(32),
  level varchar(16) default 'A级',
  address varchar(255),
  status varchar(16) default '合作中',
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table customer (
  id bigint primary key auto_increment,
  name varchar(120) not null,
  contact_name varchar(64),
  phone varchar(32),
  level varchar(16) default '普通',
  address varchar(255),
  status varchar(16) default '正常',
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table inbound_order (
  id bigint primary key auto_increment,
  order_no varchar(64) not null,
  supplier_name varchar(120),
  goods_name varchar(120),
  warehouse_id bigint,
  quantity int default 0,
  amount decimal(12,2) default 0,
  status varchar(16) default '待审核',
  operator_name varchar(64),
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table outbound_order (
  id bigint primary key auto_increment,
  order_no varchar(64) not null,
  customer_name varchar(120),
  goods_name varchar(120),
  warehouse_id bigint,
  quantity int default 0,
  amount decimal(12,2) default 0,
  status varchar(16) default '待出库',
  operator_name varchar(64),
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table stock_check (
  id bigint primary key auto_increment,
  check_no varchar(64) not null,
  goods_name varchar(120),
  warehouse_id bigint,
  book_quantity int default 0,
  real_quantity int default 0,
  difference_quantity int default 0,
  status varchar(16) default '待处理',
  operator_name varchar(64),
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table stock_alert (
  id bigint primary key auto_increment,
  goods_name varchar(120),
  alert_type varchar(32),
  current_stock int default 0,
  min_stock int default 0,
  level varchar(16) default '中',
  status varchar(16) default '待处理',
  remark varchar(255),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table notice (
  id bigint primary key auto_increment,
  title varchar(160) not null,
  content text,
  status varchar(16) default '已发布',
  publisher varchar(64),
  created_at datetime default current_timestamp,
  updated_at datetime default current_timestamp
);

create table operation_log (
  id bigint primary key auto_increment,
  operator_name varchar(64),
  module varchar(64),
  action varchar(64),
  content varchar(255),
  created_at datetime default current_timestamp
);


-- -----------------------------------------------------------------------------
-- Base demo data
-- -----------------------------------------------------------------------------
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


-- -----------------------------------------------------------------------------
-- Extended demo data
-- -----------------------------------------------------------------------------
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


-- -----------------------------------------------------------------------------
-- Additional goods data
-- -----------------------------------------------------------------------------
insert into goods(name, code, category_id, specification, unit, image, stock_quantity, min_stock, max_stock, warehouse_id, status, remark, created_at) values
('灭火器','G-2026-031',1,'4kg干粉','具','/uploads/real-goods/fire-extinguisher.jpg',34,20,120,1,'上架','消防安全物资',date_sub(now(), interval 170 day)),
('急救箱','G-2026-032',1,'企业标准套装','套','/uploads/real-goods/first-aid-kit.jpg',18,12,80,1,'上架','现场急救用品',date_sub(now(), interval 167 day)),
('对讲机','G-2026-033',5,'数字手台','台','/uploads/real-goods/walkie-talkie.jpg',26,15,90,3,'上架','库区沟通设备',date_sub(now(), interval 164 day)),
('手推车','G-2026-034',3,'折叠式150kg','辆','/uploads/real-goods/hand-truck.jpg',14,8,60,3,'上架','搬运辅助工具',date_sub(now(), interval 161 day)),
('护目镜','G-2026-035',1,'防雾透明','副','/uploads/real-goods/safety-glasses.jpg',68,60,300,1,'上架','安全防护用品',date_sub(now(), interval 158 day)),
('耳塞','G-2026-036',1,'降噪型','盒','/uploads/real-goods/ear-plugs.jpg',92,80,400,1,'上架','噪声作业防护',date_sub(now(), interval 155 day)),
('尼龙扎带','G-2026-037',2,'4x200mm','包','/uploads/real-goods/cable-tie.jpg',160,100,600,2,'上架','包装固定耗材',date_sub(now(), interval 152 day)),
('条码标签','G-2026-038',4,'50x30mm','卷','/uploads/real-goods/barcode-label.jpg',128,90,500,1,'上架','标签打印耗材',date_sub(now(), interval 149 day)),
('打印墨盒','G-2026-039',4,'黑色标准容量','个','/uploads/real-goods/printer-ink.jpg',33,20,120,1,'上架','办公打印耗材',date_sub(now(), interval 146 day)),
('标签打印机','G-2026-040',4,'热敏桌面型','台','/uploads/real-goods/label-printer.jpg',8,5,40,1,'上架','标签打印设备',date_sub(now(), interval 143 day)),
('重型货架','G-2026-041',3,'2m四层','组','/uploads/real-goods/warehouse-shelf.jpg',22,10,80,3,'上架','库位扩容设备',date_sub(now(), interval 140 day)),
('输送带','G-2026-042',3,'PVC耐磨型','米','/uploads/real-goods/conveyor-belt.jpg',45,30,160,3,'上架','输送线维修件',date_sub(now(), interval 137 day)),
('深沟球轴承','G-2026-043',3,'6205ZZ','套','/uploads/real-goods/bearing.jpg',58,40,220,3,'上架','设备常用备件',date_sub(now(), interval 134 day)),
('减速机','G-2026-044',3,'RV40','台','/uploads/real-goods/gearbox.jpg',11,8,60,3,'上架','输送设备备件',date_sub(now(), interval 131 day)),
('中间继电器','G-2026-045',5,'24VDC','个','/uploads/real-goods/relay.jpg',76,50,240,3,'上架','电控维修备件',date_sub(now(), interval 128 day)),
('开关电源','G-2026-046',5,'24V 10A','个','/uploads/real-goods/power-supply.jpg',29,20,100,3,'上架','设备电源备件',date_sub(now(), interval 125 day)),
('手持终端','G-2026-047',5,'安卓PDA','台','/uploads/real-goods/barcode-terminal.jpg',17,12,80,3,'上架','移动盘点设备',date_sub(now(), interval 122 day)),
('零件收纳盒','G-2026-048',2,'蓝色中号','个','/uploads/real-goods/warehouse-bin.jpg',140,80,500,2,'上架','小件分类收纳',date_sub(now(), interval 119 day)),
('自封袋','G-2026-049',2,'20x30cm','包','/uploads/real-goods/ziplock-bag.jpg',230,120,700,2,'上架','小件包装耗材',date_sub(now(), interval 116 day)),
('卷尺','G-2026-050',4,'5米钢卷尺','把','/uploads/real-goods/measuring-tape.jpg',41,25,150,1,'上架','现场测量工具',date_sub(now(), interval 113 day)),
('扫码枪备用电池','G-2026-051',5,'2600mAh','块','/uploads/real-goods/lithium-battery.jpg',22,15,90,3,'上架','扫码设备备件',date_sub(now(), interval 110 day)),
('叉车警示灯','G-2026-052',1,'蓝光投射','个','/uploads/real-goods/flashlight.jpg',19,12,80,1,'上架','车辆安全配件',date_sub(now(), interval 107 day)),
('库位磁吸标签','G-2026-053',4,'100x60mm','块','/uploads/real-goods/warehouse-label.jpg',155,80,500,1,'上架','库位标识维护',date_sub(now(), interval 104 day)),
('防滑地贴','G-2026-054',1,'黄黑警示','卷','/uploads/real-goods/packing-tape.jpg',48,30,180,1,'上架','通道安全标识',date_sub(now(), interval 101 day)),
('防静电手套','G-2026-055',1,'PU涂掌','包','/uploads/real-goods/nitrile-gloves.jpg',87,60,360,1,'上架','电子件操作防护',date_sub(now(), interval 98 day)),
('重型纸箱','G-2026-056',2,'五层大号','个','/uploads/real-goods/cardboard-box.jpg',340,180,900,2,'上架','大件出库包装',date_sub(now(), interval 95 day)),
('托盘护角','G-2026-057',2,'纸质L型','包','/uploads/real-goods/strapping-band.jpg',70,45,260,2,'上架','托盘打包保护',date_sub(now(), interval 92 day)),
('防潮干燥剂','G-2026-058',2,'50g袋装','箱','/uploads/real-goods/ziplock-bag.jpg',52,40,260,2,'上架','包装防潮材料',date_sub(now(), interval 89 day)),
('仓库温度计','G-2026-059',5,'电子显示','个','/uploads/real-goods/temperature-sensor.jpg',21,15,100,4,'上架','环境监测',date_sub(now(), interval 86 day)),
('冷链记录仪','G-2026-060',5,'USB温度记录','个','/uploads/real-goods/temperature-sensor.jpg',16,12,80,4,'上架','冷链追溯设备',date_sub(now(), interval 83 day)),
('工业网关','G-2026-061',5,'4G采集网关','台','/uploads/real-goods/industrial-router.jpg',9,8,50,3,'上架','设备联网',date_sub(now(), interval 80 day)),
('交换机','G-2026-062',5,'8口千兆','台','/uploads/real-goods/industrial-router.jpg',18,12,80,3,'上架','网络设备',date_sub(now(), interval 77 day)),
('电源线','G-2026-063',5,'国标1.5米','根','/uploads/real-goods/ethernet-cable.jpg',115,80,400,3,'上架','设备线材',date_sub(now(), interval 74 day)),
('接线端子','G-2026-064',5,'UK2.5B','包','/uploads/real-goods/relay.jpg',64,40,220,3,'上架','电控柜耗材',date_sub(now(), interval 71 day)),
('周转筐','G-2026-065',2,'600x400mm','个','/uploads/real-goods/warehouse-bin.jpg',190,100,600,2,'上架','拣货周转容器',date_sub(now(), interval 68 day)),
('塑料托盘','G-2026-066',2,'川字型','个','/uploads/real-goods/wooden-pallet.jpg',72,40,260,2,'上架','标准周转托盘',date_sub(now(), interval 65 day)),
('盘点贴纸','G-2026-067',4,'已盘标签','卷','/uploads/real-goods/barcode-label.jpg',88,50,260,1,'上架','盘点标识',date_sub(now(), interval 62 day)),
('马克笔','G-2026-068',4,'黑色油性','盒','/uploads/real-goods/notebook.jpg',46,30,180,1,'上架','现场标记工具',date_sub(now(), interval 59 day)),
('仓库门禁卡','G-2026-069',5,'IC卡','张','/uploads/real-goods/rfid-tag.jpg',135,80,500,1,'上架','人员通行管理',date_sub(now(), interval 56 day)),
('资产RFID标签','G-2026-070',5,'柔性抗金属','枚','/uploads/real-goods/rfid-tag.jpg',260,160,900,2,'上架','设备资产标签',date_sub(now(), interval 53 day)),
('防爆手电','G-2026-071',1,'强光便携','把','/uploads/real-goods/flashlight.jpg',13,10,70,1,'上架','特殊区域照明',date_sub(now(), interval 50 day)),
('防割手套','G-2026-072',1,'5级防割','副','/uploads/real-goods/nitrile-gloves.jpg',73,50,300,1,'上架','搬运防护',date_sub(now(), interval 47 day)),
('拉伸膜切割器','G-2026-073',2,'手持式','把','/uploads/real-goods/stretch-film.jpg',27,15,100,2,'上架','包装辅助工具',date_sub(now(), interval 44 day)),
('封箱器','G-2026-074',2,'胶带切割器','把','/uploads/real-goods/packing-tape.jpg',31,20,120,2,'上架','包装作业工具',date_sub(now(), interval 41 day)),
('气泡袋','G-2026-075',2,'小号加厚','包','/uploads/real-goods/bubble-wrap.jpg',210,120,700,2,'上架','易碎品包装',date_sub(now(), interval 38 day)),
('维修工具箱','G-2026-076',3,'五金套装','套','/uploads/real-goods/first-aid-kit.jpg',12,8,60,3,'上架','维修工具',date_sub(now(), interval 35 day)),
('链轮','G-2026-077',3,'08B-20T','个','/uploads/real-goods/bearing.jpg',25,15,100,3,'上架','输送线备件',date_sub(now(), interval 32 day)),
('传动皮带','G-2026-078',3,'A型橡胶','条','/uploads/real-goods/conveyor-belt.jpg',36,20,140,3,'上架','设备传动备件',date_sub(now(), interval 29 day)),
('无线AP','G-2026-079',5,'吸顶千兆','台','/uploads/real-goods/industrial-router.jpg',14,10,60,3,'上架','仓库无线覆盖',date_sub(now(), interval 26 day)),
('数据采集器保护套','G-2026-080',5,'PDA硅胶套','个','/uploads/real-goods/barcode-terminal.jpg',32,20,120,3,'上架','手持终端保护',date_sub(now(), interval 23 day));


-- -----------------------------------------------------------------------------
-- Final goods normalization
-- -----------------------------------------------------------------------------
update goods set name='灭火器', code='G-2026-031', category_id=1, specification='4kg干粉', unit='具', image='/uploads/real-goods/fire-extinguisher.svg', stock_quantity=34, min_stock=20, max_stock=120, warehouse_id=1, status='上架', remark='消防安全物资' where id=31;
update goods set name='急救箱', code='G-2026-032', category_id=1, specification='企业标准套装', unit='套', image='/uploads/real-goods/first-aid-kit.svg', stock_quantity=18, min_stock=12, max_stock=80, warehouse_id=1, status='上架', remark='现场急救用品' where id=32;
update goods set name='对讲机', code='G-2026-033', category_id=5, specification='数字手台', unit='台', image='/uploads/real-goods/walkie-talkie.svg', stock_quantity=26, min_stock=15, max_stock=90, warehouse_id=3, status='上架', remark='库区沟通设备' where id=33;
update goods set name='手推车', code='G-2026-034', category_id=3, specification='折叠式150kg', unit='辆', image='/uploads/real-goods/hand-truck.svg', stock_quantity=14, min_stock=8, max_stock=60, warehouse_id=3, status='上架', remark='搬运辅助工具' where id=34;
update goods set name='护目镜', code='G-2026-035', category_id=1, specification='防雾透明', unit='副', image='/uploads/real-goods/safety-glasses.svg', stock_quantity=68, min_stock=60, max_stock=300, warehouse_id=1, status='上架', remark='安全防护用品' where id=35;
update goods set name='耳塞', code='G-2026-036', category_id=1, specification='降噪型', unit='盒', image='/uploads/real-goods/ear-plugs.svg', stock_quantity=92, min_stock=80, max_stock=400, warehouse_id=1, status='上架', remark='噪声作业防护' where id=36;
update goods set name='尼龙扎带', code='G-2026-037', category_id=2, specification='4x200mm', unit='包', image='/uploads/real-goods/cable-tie.svg', stock_quantity=160, min_stock=100, max_stock=600, warehouse_id=2, status='上架', remark='包装固定耗材' where id=37;
update goods set name='条码标签', code='G-2026-038', category_id=4, specification='50x30mm', unit='卷', image='/uploads/real-goods/barcode-label.svg', stock_quantity=128, min_stock=90, max_stock=500, warehouse_id=1, status='上架', remark='标签打印耗材' where id=38;
update goods set name='打印墨盒', code='G-2026-039', category_id=4, specification='黑色标准容量', unit='个', image='/uploads/real-goods/printer-ink.svg', stock_quantity=33, min_stock=20, max_stock=120, warehouse_id=1, status='上架', remark='办公打印耗材' where id=39;
update goods set name='标签打印机', code='G-2026-040', category_id=4, specification='热敏桌面型', unit='台', image='/uploads/real-goods/label-printer.svg', stock_quantity=8, min_stock=5, max_stock=40, warehouse_id=1, status='上架', remark='标签打印设备' where id=40;
update goods set name='重型货架', code='G-2026-041', category_id=3, specification='2m四层', unit='组', image='/uploads/real-goods/warehouse-shelf.svg', stock_quantity=22, min_stock=10, max_stock=80, warehouse_id=3, status='上架', remark='库位扩容设备' where id=41;
update goods set name='输送带', code='G-2026-042', category_id=3, specification='PVC耐磨型', unit='米', image='/uploads/real-goods/conveyor-belt.svg', stock_quantity=45, min_stock=30, max_stock=160, warehouse_id=3, status='上架', remark='输送线维修件' where id=42;
update goods set name='深沟球轴承', code='G-2026-043', category_id=3, specification='6205ZZ', unit='套', image='/uploads/real-goods/bearing.svg', stock_quantity=58, min_stock=40, max_stock=220, warehouse_id=3, status='上架', remark='设备常用备件' where id=43;
update goods set name='减速机', code='G-2026-044', category_id=3, specification='RV40', unit='台', image='/uploads/real-goods/gearbox.svg', stock_quantity=11, min_stock=8, max_stock=60, warehouse_id=3, status='上架', remark='输送设备备件' where id=44;
update goods set name='中间继电器', code='G-2026-045', category_id=5, specification='24VDC', unit='个', image='/uploads/real-goods/relay.svg', stock_quantity=76, min_stock=50, max_stock=240, warehouse_id=3, status='上架', remark='电控维修备件' where id=45;
update goods set name='开关电源', code='G-2026-046', category_id=5, specification='24V 10A', unit='个', image='/uploads/real-goods/power-supply.svg', stock_quantity=29, min_stock=20, max_stock=100, warehouse_id=3, status='上架', remark='设备电源备件' where id=46;
update goods set name='手持终端', code='G-2026-047', category_id=5, specification='安卓PDA', unit='台', image='/uploads/real-goods/barcode-terminal.svg', stock_quantity=17, min_stock=12, max_stock=80, warehouse_id=3, status='上架', remark='移动盘点设备' where id=47;
update goods set name='零件收纳盒', code='G-2026-048', category_id=2, specification='蓝色中号', unit='个', image='/uploads/real-goods/warehouse-bin.svg', stock_quantity=140, min_stock=80, max_stock=500, warehouse_id=2, status='上架', remark='小件分类收纳' where id=48;
update goods set name='自封袋', code='G-2026-049', category_id=2, specification='20x30cm', unit='包', image='/uploads/real-goods/ziplock-bag.svg', stock_quantity=230, min_stock=120, max_stock=700, warehouse_id=2, status='上架', remark='小件包装耗材' where id=49;
update goods set name='卷尺', code='G-2026-050', category_id=4, specification='5米钢卷尺', unit='把', image='/uploads/real-goods/measuring-tape.svg', stock_quantity=41, min_stock=25, max_stock=150, warehouse_id=1, status='上架', remark='现场测量工具' where id=50;
update goods set name='扫码枪备用电池', code='G-2026-051', category_id=5, specification='2600mAh', unit='块', image='/uploads/real-goods/lithium-battery.svg', stock_quantity=22, min_stock=15, max_stock=90, warehouse_id=3, status='上架', remark='扫码设备备件' where id=51;
update goods set name='叉车警示灯', code='G-2026-052', category_id=1, specification='蓝光投射', unit='个', image='/uploads/real-goods/flashlight.svg', stock_quantity=19, min_stock=12, max_stock=80, warehouse_id=1, status='上架', remark='车辆安全配件' where id=52;
update goods set name='库位磁吸标签', code='G-2026-053', category_id=4, specification='100x60mm', unit='块', image='/uploads/real-goods/warehouse-label.svg', stock_quantity=155, min_stock=80, max_stock=500, warehouse_id=1, status='上架', remark='库位标识维护' where id=53;
update goods set name='防滑地贴', code='G-2026-054', category_id=1, specification='黄黑警示', unit='卷', image='/uploads/real-goods/packing-tape.svg', stock_quantity=48, min_stock=30, max_stock=180, warehouse_id=1, status='上架', remark='通道安全标识' where id=54;
update goods set name='防静电手套', code='G-2026-055', category_id=1, specification='PU涂掌', unit='包', image='/uploads/real-goods/nitrile-gloves.svg', stock_quantity=87, min_stock=60, max_stock=360, warehouse_id=1, status='上架', remark='电子件操作防护' where id=55;
update goods set name='重型纸箱', code='G-2026-056', category_id=2, specification='五层大号', unit='个', image='/uploads/real-goods/cardboard-box.svg', stock_quantity=340, min_stock=180, max_stock=900, warehouse_id=2, status='上架', remark='大件出库包装' where id=56;
update goods set name='托盘护角', code='G-2026-057', category_id=2, specification='纸质L型', unit='包', image='/uploads/real-goods/strapping-band.svg', stock_quantity=70, min_stock=45, max_stock=260, warehouse_id=2, status='上架', remark='托盘打包保护' where id=57;
update goods set name='防潮干燥剂', code='G-2026-058', category_id=2, specification='50g袋装', unit='箱', image='/uploads/real-goods/ziplock-bag.svg', stock_quantity=52, min_stock=40, max_stock=260, warehouse_id=2, status='上架', remark='包装防潮材料' where id=58;
update goods set name='仓库温度计', code='G-2026-059', category_id=5, specification='电子显示', unit='个', image='/uploads/real-goods/temperature-sensor.svg', stock_quantity=21, min_stock=15, max_stock=100, warehouse_id=4, status='上架', remark='环境监测' where id=59;
update goods set name='冷链记录仪', code='G-2026-060', category_id=5, specification='USB温度记录', unit='个', image='/uploads/real-goods/temperature-sensor.svg', stock_quantity=16, min_stock=12, max_stock=80, warehouse_id=4, status='上架', remark='冷链追溯设备' where id=60;
update goods set name='工业网关', code='G-2026-061', category_id=5, specification='4G采集网关', unit='台', image='/uploads/real-goods/industrial-router.svg', stock_quantity=9, min_stock=8, max_stock=50, warehouse_id=3, status='上架', remark='设备联网' where id=61;
update goods set name='交换机', code='G-2026-062', category_id=5, specification='8口千兆', unit='台', image='/uploads/real-goods/industrial-router.svg', stock_quantity=18, min_stock=12, max_stock=80, warehouse_id=3, status='上架', remark='网络设备' where id=62;
update goods set name='电源线', code='G-2026-063', category_id=5, specification='国标1.5米', unit='根', image='/uploads/real-goods/ethernet-cable.svg', stock_quantity=115, min_stock=80, max_stock=400, warehouse_id=3, status='上架', remark='设备线材' where id=63;
update goods set name='接线端子', code='G-2026-064', category_id=5, specification='UK2.5B', unit='包', image='/uploads/real-goods/relay.svg', stock_quantity=64, min_stock=40, max_stock=220, warehouse_id=3, status='上架', remark='电控柜耗材' where id=64;
update goods set name='周转筐', code='G-2026-065', category_id=2, specification='600x400mm', unit='个', image='/uploads/real-goods/warehouse-bin.svg', stock_quantity=190, min_stock=100, max_stock=600, warehouse_id=2, status='上架', remark='拣货周转容器' where id=65;
update goods set name='塑料托盘', code='G-2026-066', category_id=2, specification='川字型', unit='个', image='/uploads/real-goods/wooden-pallet.svg', stock_quantity=72, min_stock=40, max_stock=260, warehouse_id=2, status='上架', remark='标准周转托盘' where id=66;
update goods set name='盘点贴纸', code='G-2026-067', category_id=4, specification='已盘标签', unit='卷', image='/uploads/real-goods/barcode-label.svg', stock_quantity=88, min_stock=50, max_stock=260, warehouse_id=1, status='上架', remark='盘点标识' where id=67;
update goods set name='马克笔', code='G-2026-068', category_id=4, specification='黑色油性', unit='盒', image='/uploads/real-goods/notebook.svg', stock_quantity=46, min_stock=30, max_stock=180, warehouse_id=1, status='上架', remark='现场标记工具' where id=68;
update goods set name='仓库门禁卡', code='G-2026-069', category_id=5, specification='IC卡', unit='张', image='/uploads/real-goods/rfid-tag.svg', stock_quantity=135, min_stock=80, max_stock=500, warehouse_id=1, status='上架', remark='人员通行管理' where id=69;
update goods set name='资产RFID标签', code='G-2026-070', category_id=5, specification='柔性抗金属', unit='枚', image='/uploads/real-goods/rfid-tag.svg', stock_quantity=260, min_stock=160, max_stock=900, warehouse_id=2, status='上架', remark='设备资产标签' where id=70;
update goods set name='防爆手电', code='G-2026-071', category_id=1, specification='强光便携', unit='把', image='/uploads/real-goods/flashlight.svg', stock_quantity=13, min_stock=10, max_stock=70, warehouse_id=1, status='上架', remark='特殊区域照明' where id=71;
update goods set name='防割手套', code='G-2026-072', category_id=1, specification='5级防割', unit='副', image='/uploads/real-goods/nitrile-gloves.svg', stock_quantity=73, min_stock=50, max_stock=300, warehouse_id=1, status='上架', remark='搬运防护' where id=72;
update goods set name='拉伸膜切割器', code='G-2026-073', category_id=2, specification='手持式', unit='把', image='/uploads/real-goods/stretch-film.svg', stock_quantity=27, min_stock=15, max_stock=100, warehouse_id=2, status='上架', remark='包装辅助工具' where id=73;
update goods set name='封箱器', code='G-2026-074', category_id=2, specification='胶带切割器', unit='把', image='/uploads/real-goods/packing-tape.svg', stock_quantity=31, min_stock=20, max_stock=120, warehouse_id=2, status='上架', remark='包装作业工具' where id=74;
update goods set name='气泡袋', code='G-2026-075', category_id=2, specification='小号加厚', unit='包', image='/uploads/real-goods/bubble-wrap.svg', stock_quantity=210, min_stock=120, max_stock=700, warehouse_id=2, status='上架', remark='易碎品包装' where id=75;
update goods set name='维修工具箱', code='G-2026-076', category_id=3, specification='五金套装', unit='套', image='/uploads/real-goods/first-aid-kit.svg', stock_quantity=12, min_stock=8, max_stock=60, warehouse_id=3, status='上架', remark='维修工具' where id=76;
update goods set name='链轮', code='G-2026-077', category_id=3, specification='08B-20T', unit='个', image='/uploads/real-goods/bearing.svg', stock_quantity=25, min_stock=15, max_stock=100, warehouse_id=3, status='上架', remark='输送线备件' where id=77;
update goods set name='传动皮带', code='G-2026-078', category_id=3, specification='A型橡胶', unit='条', image='/uploads/real-goods/conveyor-belt.svg', stock_quantity=36, min_stock=20, max_stock=140, warehouse_id=3, status='上架', remark='设备传动备件' where id=78;
update goods set name='无线AP', code='G-2026-079', category_id=5, specification='吸顶千兆', unit='台', image='/uploads/real-goods/industrial-router.svg', stock_quantity=14, min_stock=10, max_stock=60, warehouse_id=3, status='上架', remark='仓库无线覆盖' where id=79;
update goods set name='数据采集器保护套', code='G-2026-080', category_id=5, specification='PDA硅胶套', unit='个', image='/uploads/real-goods/barcode-terminal.svg', stock_quantity=32, min_stock=20, max_stock=120, warehouse_id=3, status='上架', remark='手持终端保护' where id=80;


SET FOREIGN_KEY_CHECKS = 1;
