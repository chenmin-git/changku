use smart_warehouse;

insert into sys_role(id, code, name, remark) values
(1, 'ADMIN', '绠＄悊鍛?, '鎷ユ湁绯荤粺鍏ㄩ儴绠＄悊鏉冮檺'),
(2, 'KEEPER', '浠撶鍛?, '璐熻矗搴撳瓨銆佸叆搴撱€佸嚭搴撳拰鐩樼偣涓氬姟');

insert into sys_user(id, username, password, real_name, role_id, phone, status, created_at) values
(1, 'admin', '123456', '绯荤粺绠＄悊鍛?, 1, '13800000001', '鍚敤', date_sub(now(), interval 180 day)),
(2, 'keeper', '123456', '浠撳簱涓荤', 2, '13800000002', '鍚敤', date_sub(now(), interval 120 day)),
(3, 'wms01', '123456', '涓€鍙蜂粨绠″憳', 2, '13800000003', '鍚敤', date_sub(now(), interval 90 day)),
(4, 'wms02', '123456', '浜屽彿浠撶鍛?, 2, '13800000004', '鍚敤', date_sub(now(), interval 60 day));

insert into warehouse(name, code, location, manager, capacity, status, remark, created_at) values
('鍗庝笢涓€鍙蜂粨', 'WH-HD-01', '涓婃捣甯傛郸涓滄柊鍖?, '浠撳簱涓荤', 12000, '鍚敤', '甯告俯缁煎悎浠?, date_sub(now(), interval 170 day)),
('鍗庡崡鍛ㄨ浆浠?, 'WH-HN-02', '骞垮窞甯傞粍鍩斿尯', '涓€鍙蜂粨绠″憳', 8000, '鍚敤', '蹇繘蹇嚭鍛ㄨ浆浠?, date_sub(now(), interval 145 day)),
('澶囦欢涓績浠?, 'WH-BJ-03', '鑻忓窞甯傚伐涓氬洯鍖?, '浜屽彿浠撶鍛?, 6500, '鍚敤', '澶囧搧澶囦欢涓撶敤浠?, date_sub(now(), interval 100 day)),
('涓存湡闅旂浠?, 'WH-LQ-04', '鏉窞甯傞挶濉樺尯', '浠撳簱涓荤', 2400, '缁存姢涓?, '寮傚父鍝侀殧绂诲尯鍩?, date_sub(now(), interval 75 day));

insert into goods_category(name, code, status, sort_no, remark, created_at) values
('鐢靛瓙鍏冧欢', 'CAT-ELEC', '鍚敤', 1, '甯哥敤鐢靛瓙閰嶄欢', date_sub(now(), interval 175 day)),
('鍔炲叕鑰楁潗', 'CAT-OFFICE', '鍚敤', 2, '鍔炲叕鐢ㄥ搧涓庢墦鍗拌€楁潗', date_sub(now(), interval 150 day)),
('鍖呰鏉愭枡', 'CAT-PACK', '鍚敤', 3, '绾哥銆佽兌甯︺€佺紦鍐叉潗鏂?, date_sub(now(), interval 120 day)),
('璁惧澶囦欢', 'CAT-PARTS', '鍚敤', 4, '浠撳偍璁惧缁翠慨澶囦欢', date_sub(now(), interval 95 day)),
('瀹夊叏鐢ㄥ搧', 'CAT-SAFE', '鍚敤', 5, '鍔充繚涓庡畨鍏ㄩ槻鎶ょ墿璧?, date_sub(now(), interval 80 day));

insert into supplier(name, contact_name, phone, level, address, status, remark, created_at) values
('涓婃捣鏅鸿仈渚涘簲閾炬湁闄愬叕鍙?, '寮犵粡鐞?, '13910000001', 'A绾?, '涓婃捣甯傞椀琛屽尯', '鍚堜綔涓?, '浜や粯绋冲畾', date_sub(now(), interval 160 day)),
('鑻忓窞鎭掍赴鍖呰鏉愭枡鍘?, '鏉庝富绠?, '13910000002', 'A绾?, '鑻忓窞甯傚惔涓尯', '鍚堜綔涓?, '鍖呰鏉愭枡涓讳緵', date_sub(now(), interval 140 day)),
('骞垮窞瀹夌浘鍔充繚鐢ㄥ搧鏈夐檺鍏徃', '闄堢粡鐞?, '13910000003', 'B绾?, '骞垮窞甯傜櫧浜戝尯', '鍚堜綔涓?, '瀹夊叏鐢ㄥ搧渚涘簲', date_sub(now(), interval 118 day)),
('鏉窞绮惧瘑澶囦欢鏈夐檺鍏徃', '鍛ㄥ伐', '13910000004', 'B绾?, '鏉窞甯傛花姹熷尯', '鍚堜綔涓?, '澶囦欢浜ゆ湡闇€璺熻釜', date_sub(now(), interval 86 day)),
('鍗椾含浜戜粨璐告槗鏈夐檺鍏徃', '鐜嬬粡鐞?, '13910000005', 'C绾?, '鍗椾含甯傛睙瀹佸尯', '鏆傚仠', '浠锋牸闇€澶嶆牳', date_sub(now(), interval 66 day));

insert into customer(name, contact_name, phone, level, address, status, remark, created_at) values
('鍗庝笢杩愯惀涓績', '璧典富绠?, '13710000001', '閲嶇偣', '涓婃捣甯傛郸涓滄柊鍖?, '姝ｅ父', '鏈堝害閰嶉€佸鎴?, date_sub(now(), interval 150 day)),
('鍗椾含鍒嗘嫧涓績', '閽变富绠?, '13710000002', '鏅€?, '鍗椾含甯傞洦鑺卞彴鍖?, '姝ｅ父', '鍛ㄥ害琛ヨ揣', date_sub(now(), interval 130 day)),
('鏉窞鍞悗鏈嶅姟閮?, '瀛欎富绠?, '13710000003', '閲嶇偣', '鏉窞甯備笂鍩庡尯', '姝ｅ父', '澶囦欢娑堣€楄緝蹇?, date_sub(now(), interval 100 day)),
('骞垮窞椤圭洰缁?, '鏉庝富绠?, '13710000004', '鏅€?, '骞垮窞甯傚ぉ娌冲尯', '姝ｅ父', '椤圭洰鍒堕鐢?, date_sub(now(), interval 80 day)),
('鑻忓窞鐮斿彂涓績', '閮戜富绠?, '13710000005', '鏅€?, '鑻忓窞甯傚伐涓氬洯鍖?, '姝ｅ父', '鐮斿彂鑰楁潗棰嗙敤', date_sub(now(), interval 55 day));

insert into goods(name, code, category_id, specification, unit, image, stock_quantity, min_stock, max_stock, warehouse_id, status, remark, created_at) values
('鎵爜鏋數姹?, 'G-2026-001', 1, '7.4V/2200mAh', '鍧?, '/uploads/demo/battery.svg', 42, 50, 300, 1, '涓婃灦', '浣庝簬瀹夊叏搴撳瓨', date_sub(now(), interval 168 day)),
('鐑晱鏍囩绾?, 'G-2026-002', 2, '80mm*60mm', '鍗?, '/uploads/demo/label.svg', 860, 200, 2000, 1, '涓婃灦', '甯哥敤鑰楁潗', date_sub(now(), interval 155 day)),
('浜斿眰鐡︽绾哥', 'G-2026-003', 3, '500*400*300', '涓?, '/uploads/demo/box.svg', 1200, 300, 5000, 2, '涓婃灦', '鍖呰涓绘潗', date_sub(now(), interval 149 day)),
('鍙夎溅杞儙', 'G-2026-004', 4, '28*9-15', '鏉?, '/uploads/demo/tire.svg', 18, 20, 120, 3, '涓婃灦', '闇€琛ヨ揣', date_sub(now(), interval 132 day)),
('闃插壊鎵嬪', 'G-2026-005', 5, 'L鐮?, '鍙?, '/uploads/demo/glove.svg', 260, 100, 1000, 2, '涓婃灦', '鍔充繚鐢ㄥ搧', date_sub(now(), interval 120 day)),
('鎵撳嵃鏈虹⒊甯?, 'G-2026-006', 2, '110mm*300m', '鍗?, '/uploads/demo/ribbon.svg', 76, 80, 600, 1, '涓婃灦', '鎺ヨ繎涓嬮檺', date_sub(now(), interval 96 day)),
('缂撳啿姘旀场鑶?, 'G-2026-007', 3, '60cm*100m', '鍗?, '/uploads/demo/film.svg', 340, 120, 1200, 2, '涓婃灦', '鍑哄簱棰戠箒', date_sub(now(), interval 80 day)),
('浠撳偍璐ф灦妯', 'G-2026-008', 4, '2.7m', '鏍?, '/uploads/demo/beam.svg', 64, 30, 300, 3, '涓婃灦', '缁翠慨澶囦欢', date_sub(now(), interval 72 day)),
('RFID鏍囩', 'G-2026-009', 1, 'UHF', '寮?, '/uploads/demo/rfid.svg', 5400, 1000, 10000, 1, '涓婃灦', '鐩樼偣浣跨敤', date_sub(now(), interval 60 day)),
('瀹夊叏璀︾ず鑳跺甫', 'G-2026-010', 5, '榛勯粦 48mm', '鍗?, '/uploads/demo/tape.svg', 95, 120, 800, 4, '涓婃灦', '闅旂浠撻渶琛ヨ揣', date_sub(now(), interval 44 day));

insert into inbound_order(order_no, supplier_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('IN2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '涓婃捣鏅鸿仈渚涘簲閾炬湁闄愬叕鍙?,'鑻忓窞鎭掍赴鍖呰鏉愭枡鍘?,'骞垮窞瀹夌浘鍔充繚鐢ㄥ搧鏈夐檺鍏徃','鏉窞绮惧瘑澶囦欢鏈夐檺鍏徃','鍗椾含浜戜粨璐告槗鏈夐檺鍏徃'),
       elt(1 + mod(n,10), '鎵爜鏋數姹?,'鐑晱鏍囩绾?,'浜斿眰鐡︽绾哥','鍙夎溅杞儙','闃插壊鎵嬪','鎵撳嵃鏈虹⒊甯?,'缂撳啿姘旀场鑶?,'浠撳偍璐ф灦妯','RFID鏍囩','瀹夊叏璀︾ず鑳跺甫'),
       1 + mod(n,4),
       20 + mod(n * 13, 260),
       round((20 + mod(n * 13, 260)) * (8 + mod(n, 80)), 2),
       elt(1 + mod(n,4), '寰呭鏍?,'宸插叆搴?,'宸查┏鍥?,'宸插叆搴?),
       elt(1 + mod(n,3), '浠撳簱涓荤','涓€鍙蜂粨绠″憳','浜屽彿浠撶鍛?),
       '绯荤粺鍒濆鍖栨紨绀哄叆搴撳崟',
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
       elt(1 + mod(n,5), '鍗庝笢杩愯惀涓績','鍗椾含鍒嗘嫧涓績','鏉窞鍞悗鏈嶅姟閮?,'骞垮窞椤圭洰缁?,'鑻忓窞鐮斿彂涓績'),
       elt(1 + mod(n,10), '鎵爜鏋數姹?,'鐑晱鏍囩绾?,'浜斿眰鐡︽绾哥','鍙夎溅杞儙','闃插壊鎵嬪','鎵撳嵃鏈虹⒊甯?,'缂撳啿姘旀场鑶?,'浠撳偍璐ф灦妯','RFID鏍囩','瀹夊叏璀︾ず鑳跺甫'),
       1 + mod(n,4),
       10 + mod(n * 9, 180),
       round((10 + mod(n * 9, 180)) * (10 + mod(n, 90)), 2),
       elt(1 + mod(n,4), '寰呭嚭搴?,'宸插嚭搴?,'宸插彇娑?,'宸插嚭搴?),
       elt(1 + mod(n,3), '浠撳簱涓荤','涓€鍙蜂粨绠″憳','浜屽彿浠撶鍛?),
       '绯荤粺鍒濆鍖栨紨绀哄嚭搴撳崟',
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
('CHK2026001', '鎵爜鏋數姹?, 1, 46, 42, -4, '寰呭鐞?, '浠撳簱涓荤', '浣庡簱瀛橀渶澶嶆牳', date_sub(now(), interval 32 day)),
('CHK2026002', '鐑晱鏍囩绾?, 1, 860, 858, -2, '宸插畬鎴?, '涓€鍙蜂粨绠″憳', '璇樊姝ｅ父', date_sub(now(), interval 28 day)),
('CHK2026003', '鍙夎溅杞儙', 3, 20, 18, -2, '寰呭鐞?, '浜屽彿浠撶鍛?, '闇€纭棰嗙敤璁板綍', date_sub(now(), interval 20 day)),
('CHK2026004', 'RFID鏍囩', 1, 5400, 5410, 10, '宸插畬鎴?, '浠撳簱涓荤', '鐩樼泩鍏ヨ处', date_sub(now(), interval 12 day)),
('CHK2026005', '瀹夊叏璀︾ず鑳跺甫', 4, 100, 95, -5, '寰呭鐞?, '涓€鍙蜂粨绠″憳', '闅旂浠撻鐢ㄦ湭鐧昏', date_sub(now(), interval 6 day));

insert into stock_alert(goods_name, alert_type, current_stock, min_stock, level, status, remark, created_at) values
('鎵爜鏋數姹?, '浣庡簱瀛?, 42, 50, '楂?, '寰呭鐞?, '寤鸿鏈懆琛ヨ揣 120 鍧?, date_sub(now(), interval 10 day)),
('鍙夎溅杞儙', '浣庡簱瀛?, 18, 20, '楂?, '寰呭鐞?, '璁惧缁翠慨澶囦欢涓嶈冻', date_sub(now(), interval 8 day)),
('鎵撳嵃鏈虹⒊甯?, '鎺ヨ繎涓嬮檺', 76, 80, '涓?, '寰呭鐞?, '寤鸿璺熼殢鏍囩绾镐竴璧烽噰璐?, date_sub(now(), interval 5 day)),
('瀹夊叏璀︾ず鑳跺甫', '浣庡簱瀛?, 95, 120, '涓?, '寰呭鐞?, '闅旂浠撴秷鑰楀鍔?, date_sub(now(), interval 3 day)),
('RFID鏍囩', '搴撳瓨鍏呰冻', 5400, 1000, '浣?, '宸插鐞?, '鏃犻渶琛ヨ揣', date_sub(now(), interval 15 day));

insert into notice(title, content, status, publisher, created_at) values
('鏈堝害鐩樼偣瀹夋帓', '璇峰悇浠撳簱鍦ㄦ湰鍛ㄤ簲鍓嶅畬鎴愰噸鐐硅揣鍝佺洏鐐广€?, '宸插彂甯?, '绯荤粺绠＄悊鍛?, date_sub(now(), interval 14 day)),
('浣庡簱瀛樺鐞嗘彁閱?, '搴撳瓨棰勮绛夌骇涓洪珮鐨勬暟鎹渶瑕佷紭鍏堝鐞嗗苟鐧昏缁撴灉銆?, '宸插彂甯?, '绯荤粺绠＄悊鍛?, date_sub(now(), interval 9 day)),
('鍏ュ簱鍗曞鏍歌鑼?, '鍏ュ簱鍗曢渶鏍稿渚涘簲鍟嗐€佹暟閲忋€侀噾棰濆拰浠撳簱淇℃伅銆?, '鑽夌', '绯荤粺绠＄悊鍛?, date_sub(now(), interval 4 day));

insert into operation_log(operator_name, module, action, content, created_at) values
('绯荤粺绠＄悊鍛?, '鐢ㄦ埛', '鐧诲綍', '绠＄悊鍛樼櫥褰曠郴缁?, date_sub(now(), interval 2 day)),
('浠撳簱涓荤', '鍏ュ簱鍗?, '瀹℃牳', '瀹℃牳鍏ュ簱鍗?IN2026008', date_sub(now(), interval 1 day)),
('涓€鍙蜂粨绠″憳', '搴撳瓨棰勮', '澶勭悊', '澶勭悊鐑晱鏍囩绾搁璀?, date_sub(now(), interval 12 hour)),
('浜屽彿浠撶鍛?, '鐩樼偣', '鏂板', '鏂板鍙夎溅杞儙鐩樼偣璁板綍', date_sub(now(), interval 3 hour));
use smart_warehouse;

insert into goods(name, code, category_id, specification, unit, image, stock_quantity, min_stock, max_stock, warehouse_id, status, remark, created_at) values
('鏃犵嚎鎵爜鏋?, 'G-2026-011', 1, '2.4G/USB', '鎶?, '/uploads/demo/scanner.png', 32, 20, 180, 1, '涓婃灦', '鍒嗘嫞鍖哄父鐢ㄨ澶?, date_sub(now(), interval 38 day)),
('鏍囧噯鏈ㄦ墭鐩?, 'G-2026-012', 3, '1200*1000mm', '涓?, '/uploads/demo/pallet.png', 260, 80, 900, 2, '涓婃灦', '鏁存墭鍏ュ簱浣跨敤', date_sub(now(), interval 36 day)),
('瀹夊叏澶寸洈', 'G-2026-013', 5, '榛勮壊/鍙皟鑺?, '椤?, '/uploads/demo/helmet.png', 84, 60, 500, 4, '涓婃灦', '璁垮涓庝綔涓氫汉鍛橀鐢?, date_sub(now(), interval 34 day)),
('鍙嶅厜鑳屽績', 'G-2026-014', 5, '鍧囩爜', '浠?, '/uploads/demo/vest.png', 118, 80, 600, 4, '涓婃灦', '澶滈棿浣滀笟鐢ㄥ搧', date_sub(now(), interval 33 day)),
('灏佺鑳跺甫', 'G-2026-015', 3, '60mm*100m', '鍗?, '/uploads/demo/seal.png', 430, 160, 1600, 2, '涓婃灦', '鍖呰绾挎秷鑰楀搧', date_sub(now(), interval 32 day)),
('鍛ㄨ浆灏忚溅', 'G-2026-016', 4, '涓夊眰闈欓煶杞?, '鍙?, '/uploads/demo/cart.png', 22, 12, 100, 3, '涓婃灦', '搴撳唴鎷ｈ揣鍛ㄨ浆', date_sub(now(), interval 30 day)),
('娓╂箍搴︿紶鎰熷櫒', 'G-2026-017', 1, 'LoRa/鐢垫睜娆?, '涓?, '/uploads/demo/sensor.png', 46, 30, 240, 1, '涓婃灦', '搴撳尯鐜鐩戞祴', date_sub(now(), interval 28 day)),
('浠撳簱缃戝叧', 'G-2026-018', 1, '4G/WiFi', '鍙?, '/uploads/demo/router.png', 16, 10, 80, 1, '涓婃灦', '鐗╄仈璁惧鎺ュ叆', date_sub(now(), interval 27 day)),
('鏁版嵁绾跨紗', 'G-2026-019', 1, 'Type-C 1.5m', '鏍?, '/uploads/demo/cable.png', 520, 180, 1800, 1, '涓婃灦', '璁惧缁存姢澶囩敤', date_sub(now(), interval 25 day)),
('闃查渿鍨墖', 'G-2026-020', 4, '姗¤兌 80mm', '鐗?, '/uploads/demo/pad.png', 760, 240, 2200, 3, '涓婃灦', '璁惧瀹夎杈呮潗', date_sub(now(), interval 24 day)),
('杈撻€佺嚎鐢垫満', 'G-2026-021', 4, '1.5kW', '鍙?, '/uploads/demo/motor.png', 9, 12, 60, 3, '涓婃灦', '浣庝簬瀹夊叏搴撳瓨', date_sub(now(), interval 22 day)),
('宸ヤ笟浜ゆ崲鏈?, 'G-2026-022', 1, '8鍙ｅ崈鍏?, '鍙?, '/uploads/demo/switch.png', 24, 16, 120, 1, '涓婃灦', '缃戠粶澶囦欢', date_sub(now(), interval 21 day)),
('闃插皹鍙ｇ僵', 'G-2026-023', 5, 'KN95', '鐩?, '/uploads/demo/mask.png', 150, 120, 1000, 4, '涓婃灦', '绮夊皹鍖哄鐢?, date_sub(now(), interval 18 day)),
('搴旀€ョ収鏄庣伅', 'G-2026-024', 4, '鍙屽ご LED', '鐩?, '/uploads/demo/lamp.png', 36, 24, 160, 3, '涓婃灦', '瀹夊叏宸℃鐢ㄥ搧', date_sub(now(), interval 16 day)),
('搴撻棬閿佸叿', 'G-2026-025', 4, '鐢靛瓙閿?, '濂?, '/uploads/demo/lock.png', 14, 10, 80, 3, '涓婃灦', '搴撻棬缁存姢澶囦欢', date_sub(now(), interval 15 day)),
('鍒嗘嫞鏂欑洅', 'G-2026-026', 3, '钃濊壊 400*300', '涓?, '/uploads/demo/tray.png', 640, 180, 1800, 2, '涓婃灦', '鍒嗘嫞鍙板鍣?, date_sub(now(), interval 12 day)),
('鐢靛瓙鍙扮Г', 'G-2026-027', 4, '150kg', '鍙?, '/uploads/demo/scale.png', 12, 8, 60, 3, '涓婃灦', '绉伴噸澶嶆牳璁惧', date_sub(now(), interval 10 day)),
('鍏呯數搴曞骇', 'G-2026-028', 1, '鎵爜鏋厤濂?, '涓?, '/uploads/demo/charger.png', 28, 20, 160, 1, '涓婃灦', '鎵爜鏋厤浠?, date_sub(now(), interval 8 day)),
('璐ф灦鏍囩', 'G-2026-029', 2, '90*40mm', '寮?, '/uploads/demo/shelf-tag.png', 3200, 800, 8000, 1, '涓婃灦', '搴撲綅鏍囪瘑', date_sub(now(), interval 6 day)),
('鎷変几缂犵粫鑶?, 'G-2026-030', '3', '50cm*300m', '鍗?, '/uploads/demo/wrap.png', 210, 120, 900, 2, '涓婃灦', '鏁存墭鍖呰鑰楁潗', date_sub(now(), interval 4 day));

insert into supplier(name, contact_name, phone, level, address, status, remark, created_at) values
('鏃犻敗杩呮嵎璁惧鏈夐檺鍏徃', '鍒樼粡鐞?, '13910000006', 'A绾?, '鏃犻敗甯傛柊鍚村尯', '鍚堜綔涓?, '鎵爜璁惧涓庨厤浠?, date_sub(now(), interval 50 day)),
('甯稿窞瀹夎埅瀹夊叏鐢ㄥ搧鍘?, '浣曚富绠?, '13910000007', 'B绾?, '甯稿窞甯傛杩涘尯', '鍚堜綔涓?, '瀹夊叏鐢ㄥ搧琛ュ厖渚涘簲鍟?, date_sub(now(), interval 48 day)),
('瀹佹尝鎵樼洏鍖呰鏈夐檺鍏徃', '璁哥粡鐞?, '13910000008', 'A绾?, '瀹佹尝甯傚寳浠戝尯', '鍚堜綔涓?, '鎵樼洏涓庡寘瑁呮潗鏂?, date_sub(now(), interval 46 day)),
('鍚堣偉鏅烘帶鐗╄仈绉戞妧', '椹伐', '13910000009', 'B绾?, '鍚堣偉甯傞珮鏂板尯', '鍚堜綔涓?, '浼犳劅鍣ㄤ笌缃戝叧', date_sub(now(), interval 42 day)),
('姝︽眽浠撳偍澶囦欢涓績', '閮粡鐞?, '13910000010', 'B绾?, '姝︽眽甯備笢瑗挎箹鍖?, '鍚堜綔涓?, '杈撻€佺嚎涓庡簱闂ㄥ浠?, date_sub(now(), interval 39 day));

insert into customer(name, contact_name, phone, level, address, status, remark, created_at) values
('鎴愰兘鍒嗘嫧涓績', '钂嬩富绠?, '13710000006', '閲嶇偣', '鎴愰兘甯傞緳娉夐┛鍖?, '姝ｅ父', '瑗垮崡鍖哄煙鍒嗘嫧', date_sub(now(), interval 52 day)),
('閲嶅簡鍞悗绔?, '鍞愪富绠?, '13710000007', '鏅€?, '閲嶅簡甯傛笣鍖楀尯', '姝ｅ父', '鍞悗澶囦欢棰嗙敤', date_sub(now(), interval 49 day)),
('鍚堣偉杩愯惀浠?, '涓佷富绠?, '13710000008', '鏅€?, '鍚堣偉甯傚寘娌冲尯', '姝ｅ父', '鍖哄煙琛ヨ揣', date_sub(now(), interval 45 day)),
('姝︽眽椤圭洰浠?, '琚佷富绠?, '13710000009', '閲嶇偣', '姝︽眽甯傛睙澶忓尯', '姝ｅ父', '椤圭洰鍒堕鐢?, date_sub(now(), interval 43 day)),
('鍘﹂棬鍓嶇疆浠?, '鏋椾富绠?, '13710000010', '鏅€?, '鍘﹂棬甯傞泦缇庡尯', '姝ｅ父', '鍓嶇疆搴撳瓨琛ュ厖', date_sub(now(), interval 40 day));

insert into stock_alert(goods_name, alert_type, current_stock, min_stock, level, status, remark, created_at) values
('杈撻€佺嚎鐢垫満', '浣庡簱瀛?, 9, 12, '楂?, '寰呭鐞?, '寤鸿绔嬪嵆琛ヨ揣 20 鍙?, date_sub(now(), interval 2 day)),
('鍙夎溅杞儙', '浣庡簱瀛?, 18, 20, '楂?, '寰呭鐞?, '缁翠慨瀛ｆ秷鑰楄緝蹇?, date_sub(now(), interval 2 day)),
('鎵爜鏋數姹?, '浣庡簱瀛?, 42, 50, '楂?, '寰呭鐞?, '涓€绾胯澶囧鐢ㄤ笉瓒?, date_sub(now(), interval 1 day)),
('鎵撳嵃鏈虹⒊甯?, '鎺ヨ繎涓嬮檺', 76, 80, '涓?, '寰呭鐞?, '寤鸿闅忔爣绛剧焊鍚堝苟閲囪喘', date_sub(now(), interval 1 day)),
('鎷変几缂犵粫鑶?, '鎺ヨ繎涓嬮檺', 210, 120, '浣?, '宸插鐞?, '鏆備笉闇€瑕佽ˉ璐?, date_sub(now(), interval 3 day));

insert into stock_check(check_no, goods_name, warehouse_id, book_quantity, real_quantity, difference_quantity, status, operator_name, remark, created_at) values
('CHK2026006', '杈撻€佺嚎鐢垫満', 3, 10, 9, -1, '寰呭鐞?, '浜屽彿浠撶鍛?, '缁翠慨棰嗙敤寰呰ˉ鐧昏', date_sub(now(), interval 3 day)),
('CHK2026007', '鏍囧噯鏈ㄦ墭鐩?, 2, 260, 260, 0, '宸插畬鎴?, '涓€鍙蜂粨绠″憳', '璐﹀疄涓€鑷?, date_sub(now(), interval 2 day)),
('CHK2026008', '璐ф灦鏍囩', 1, 3200, 3188, -12, '寰呭鐞?, '浠撳簱涓荤', '鍒嗘嫞鍖烘秷鑰楀樊寮?, date_sub(now(), interval 1 day));

insert into inbound_order(order_no, supplier_name, goods_name, warehouse_id, quantity, amount, status, operator_name, remark, created_at)
select concat('INX2026', lpad(n, 4, '0')),
       elt(1 + mod(n,5), '鏃犻敗杩呮嵎璁惧鏈夐檺鍏徃','甯稿窞瀹夎埅瀹夊叏鐢ㄥ搧鍘?,'瀹佹尝鎵樼洏鍖呰鏈夐檺鍏徃','鍚堣偉鏅烘帶鐗╄仈绉戞妧','姝︽眽浠撳偍澶囦欢涓績'),
       elt(1 + mod(n,20), '鏃犵嚎鎵爜鏋?,'鏍囧噯鏈ㄦ墭鐩?,'瀹夊叏澶寸洈','鍙嶅厜鑳屽績','灏佺鑳跺甫','鍛ㄨ浆灏忚溅','娓╂箍搴︿紶鎰熷櫒','浠撳簱缃戝叧','鏁版嵁绾跨紗','闃查渿鍨墖','杈撻€佺嚎鐢垫満','宸ヤ笟浜ゆ崲鏈?,'闃插皹鍙ｇ僵','搴旀€ョ収鏄庣伅','搴撻棬閿佸叿','鍒嗘嫞鏂欑洅','鐢靛瓙鍙扮Г','鍏呯數搴曞骇','璐ф灦鏍囩','鎷変几缂犵粫鑶?),
       1 + mod(n,4),
       15 + mod(n * 11, 220),
       round((15 + mod(n * 11, 220)) * (12 + mod(n, 75)), 2),
       elt(1 + mod(n,4), '寰呭鏍?,'宸插叆搴?,'宸查┏鍥?,'宸插叆搴?),
       elt(1 + mod(n,3), '浠撳簱涓荤','涓€鍙蜂粨绠″憳','浜屽彿浠撶鍛?),
       '鎵╁睍婕旂ず鍏ュ簱鍗?,
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
       elt(1 + mod(n,5), '鎴愰兘鍒嗘嫧涓績','閲嶅簡鍞悗绔?,'鍚堣偉杩愯惀浠?,'姝︽眽椤圭洰浠?,'鍘﹂棬鍓嶇疆浠?),
       elt(1 + mod(n,20), '鏃犵嚎鎵爜鏋?,'鏍囧噯鏈ㄦ墭鐩?,'瀹夊叏澶寸洈','鍙嶅厜鑳屽績','灏佺鑳跺甫','鍛ㄨ浆灏忚溅','娓╂箍搴︿紶鎰熷櫒','浠撳簱缃戝叧','鏁版嵁绾跨紗','闃查渿鍨墖','杈撻€佺嚎鐢垫満','宸ヤ笟浜ゆ崲鏈?,'闃插皹鍙ｇ僵','搴旀€ョ収鏄庣伅','搴撻棬閿佸叿','鍒嗘嫞鏂欑洅','鐢靛瓙鍙扮Г','鍏呯數搴曞骇','璐ф灦鏍囩','鎷変几缂犵粫鑶?),
       1 + mod(n,4),
       8 + mod(n * 7, 160),
       round((8 + mod(n * 7, 160)) * (15 + mod(n, 60)), 2),
       elt(1 + mod(n,4), '寰呭嚭搴?,'宸插嚭搴?,'宸插彇娑?,'宸插嚭搴?),
       elt(1 + mod(n,3), '浠撳簱涓荤','涓€鍙蜂粨绠″憳','浜屽彿浠撶鍛?),
       '鎵╁睍婕旂ず鍑哄簱鍗?,
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
