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
