DROP DATABASE IF EXISTS UBIKE;

CREATE DATABASE UBIKE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE UBIKE;

CREATE TABLE UBIKE_place(
  站點代號 int NOT NULL UNIQUE,
  中文場站名稱 varchar(14) ,
  中文場站區域 varchar(5),
  場站總停車格 int,
  可借車位數 int,
  可還空位數 int,
  PRIMARY KEY (站點代號)
);
INSERT INTO UBIKE_place VALUE('1001','大鵬華城','新店區','38','31','6');
INSERT INTO UBIKE_place VALUE('1002','汐止火車站','汐止區','56','1','52');
INSERT INTO UBIKE_place VALUE('1003','汐止區公所','汐止區','46','19','24');
INSERT INTO UBIKE_place VALUE('1004','國泰綜合醫院','汐止區','56','23','31');
INSERT INTO UBIKE_place VALUE('1005','裕隆公園','新店區','40','9','24');
INSERT INTO UBIKE_place VALUE('1006','捷運大坪林站(5號出口)','新店區','94','43','45');

CREATE TABLE UBIKE_condition(
  車輛編號 VARCHAR(4) NOT NULL UNIQUE,
  停放站點代號 int ,
  車輛狀況 VARCHAR(4) ,
  供應商編號 VARCHAR(4),
  PRIMARY KEY (車輛編號)
);
INSERT INTO UBIKE_condition VALUE('0001','1001','完好','S001');
INSERT INTO UBIKE_condition VALUE('0002','1002','完好','S001');
INSERT INTO UBIKE_condition VALUE('0003','1003','車鈴故障','S001');
INSERT INTO UBIKE_condition VALUE('0004','1004','完好','S002');
INSERT INTO UBIKE_condition VALUE('0005','1005','後輪漏氣','S002');
INSERT INTO UBIKE_condition VALUE('0006','1006','完好','S002');
INSERT INTO UBIKE_condition VALUE('0007','1006','完好','S002');

CREATE TABLE suppliers(
  供應商編號 VARCHAR(4) NOT NULL UNIQUE,
  供應商名稱 VARCHAR(20),
  電話號碼 int,
  供應商地址 VARCHAR(40),
  PRIMARY KEY (供應商編號)
);
INSERT INTO suppliers VALUES ('S001','a科技公司',0965888888,'桃園市中壢區中北路200號');
INSERT INTO suppliers VALUES ('S002','b科技公司',0965999999,'台中市西屯區中北路400號');

CREATE TABLE UBIKE_user_register(
  悠遊卡號碼 VARCHAR(10) NOT NULL UNIQUE,
  姓名 VARCHAR(8),
  手機號碼 int,
  證件號碼 VARCHAR(10),
  生日 date,
  密碼 VARCHAR(10),
  電子信箱 VARCHAR(25),
  PRIMARY KEY (悠遊卡號碼)
);
INSERT INTO UBIKE_user_register VALUE('1234567891','小a','0965441921','A111111111','2020-05-20','123456789','1234567891@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567892','小b','0965441922','A111111112','2020-05-20','123456788','1234567892@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567893','小c','0965441923','A111111113','2020-05-20','123456787','1234567893@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567894','小d','0965441924','A111111114','2020-05-20','123456786','1234567894@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567895','小e','0965441925','A111111115','2020-05-20','123456785','1234567895@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567896','小f','0965441926','A111111116','2020-05-20','123456784','1234567896@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567897','小g','0965441927','A111111117','2020-05-20','123456783','1234567897@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567898','小h','0965441928','A111111118','2020-05-20','123456782','1234567898@gmail.com');
INSERT INTO UBIKE_user_register VALUE('1234567899','小i','0965441929','A111111119','2020-05-20','123456781','1234567899@gmail.com');


CREATE TABLE UBIKE_user(
  車輛編號 VARCHAR(4) NOT NULL,
  姓名 VARCHAR(8),
  悠遊卡號碼 VARCHAR(10) NOT NULL,
  借用時間 datetime,
  歸還時間 datetime,
  借用站點代號 VARCHAR(4),
  歸還站點代號 VARCHAR(4),
  PRIMARY KEY (悠遊卡號碼,借用時間)
);
INSERT INTO UBIKE_user VALUE('0001','小a','1234567891','2020-05-20 08:05:00','2020-05-20 08:55:00','1001','1002');
INSERT INTO UBIKE_user VALUE('0002','小b','1234567892','2020-05-20 10:07:00','2020-05-20 10:31:00','1001','1003');
INSERT INTO UBIKE_user VALUE('0003','小c','1234567893','2020-05-20 18:15:00','2020-05-20 18:45:00','1001','1004');
INSERT INTO UBIKE_user VALUE('0004','小d','1234567894','2020-05-20 09:15:00','2020-05-20 09:25:00','1001','1005');
INSERT INTO UBIKE_user VALUE('0001','小e','1234567895','2020-05-20 20:11:00','2020-05-20 20:45:00','1002','1004');
INSERT INTO UBIKE_user VALUE('0005','小f','1234567896','2020-05-20 07:15:00','2020-05-20 07:33:00','1002','1003');
INSERT INTO UBIKE_user VALUE('0006','小g','1234567897','2020-05-20 22:19:00','2020-05-20 22:41:00','1002','1005');
INSERT INTO UBIKE_user VALUE('0002','小h','1234567898','2020-05-20 12:39:00','2020-05-20 12:47:00','1003','1006');
INSERT INTO UBIKE_user VALUE('0007','小i','1234567899','2020-05-20 11:14:00','2020-05-20 11:31:00','1004','1006');
INSERT INTO UBIKE_user VALUE('0007','小i','1234567899','2020-05-20 12:20:00','2020-05-20 12:45:00','1006','1002');


DROP VIEW IF EXISTS borrowTime_view;
CREATE VIEW borrowTime_view AS 
select ubike_user.悠遊卡號碼,TIMESTAMPDIFF( minute,ubike_user.借用時間 , ubike_user.歸還時間) as 借用時間
from ubike_user
ORDER BY ubike_user.悠遊卡號碼 ;

#借還及費用記錄查詢(前半個小時免費，之后每半個小時10元)
SELECT ubike_user.悠遊卡號碼,ubike_user.車輛編號,ubike_user_register.姓名,ubike_user.借用時間,ubike_user.歸還時間,
ubike_user.借用站點代號,ubike_user.歸還站點代號,borrowtime_view.借用時間,if(borrowtime_view.借用時間>30,(CEILING( borrowtime_view.借用時間/30)*10),0) as 租賃費用
FROM ubike_user,ubike_user_register,borrowtime_view
WHERE (ubike_user.悠遊卡號碼=1234567891) AND (ubike_user.悠遊卡號碼=ubike_user_register.悠遊卡號碼) and (borrowtime_view.悠遊卡號碼=
ubike_user.悠遊卡號碼)
ORDER BY ubike_user.借用時間 ASC;


#尋找壞損車輛，及時維修
SELECT ubike_user.悠遊卡號碼,ubike_user.車輛編號,ubike_user.借用站點代號,ubike_user.歸還站點代號,ubike_condition.車輛狀況,ubike_condition.供應商編號
FROM ubike_user,ubike_condition
where (ubike_user.車輛編號=ubike_condition.車輛編號) AND (ubike_condition.車輛狀況!='完好')
ORDER BY ubike_user.車輛編號 ASC;


SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_suppliers.txt' FROM suppliers;
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_condition.txt' FROM ubike_condition;
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_place.txt' FROM ubike_place;
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_user.txt' FROM ubike_user;
SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_user_register.txt' FROM ubike_user_register;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_suppliers.txt' INTO TABLE suppliers;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_condition.txt' INTO TABLE ubike_condition;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_place.txt' INTO TABLE ubike_place;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_user.txt' INTO TABLE ubike_user;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ubike_user_register.txt' INTO TABLE ubike_user_register;












