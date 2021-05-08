show databases;
create database Insurance01;
use Insurance01;
create table PERSON(driver_id varchar(30) primary key, name varchar(30), address varchar(30));
create table CAR(Regno varchar(30) primary key, model varchar(30), year int);
create table ACCIDENT(report_number int primary key, adate date, location varchar(30));
create table OWNS(driver_id varchar(30), Regno varchar(30), primary key(driver_id,Regno), foreign key(driver_id) references PERSON(driver_id), foreign key(Regno) references CAR(Regno));
create table PARTICIPATED(driver_id varchar(30), Regno varchar(30), report_number int, damage_amount int, primary key(driver_id, Regno), foreign key(driver_id, Regno) references OWNS(driver_id, Regno));
show tables;
insert into PERSON values('07K','Brad','Mangalore');
insert into CAR values('5F','Bugatti','2013');
insert into ACCIDENT values('12','2007/1/21','Mangalore');
insert into OWNS values('07K','5F');
insert into PARTICIPATED values('07K','5F','12','555555');
select * from PERSON;

-- a. Update the damage amount for the car with a specific Regno in the accident with report number 12 to
-- 25000.

update PARTICIPATED set damage_amount='25000' where Regno='5F' AND report_number='12';
select * from PARTICIPATED;


-- Add a new accident to the database.

insert into ACCIDENT values('13','1967/09/02','Bermuda');
select * from ACCIDENT;

-- Find the total number of people who owned cars that involved in accidents in 2008.

select count(*) from ACCIDENT where adate>'2007/12/31' AND adate<'2009/01/01';

-- Find the number of accidents in which cars belonging to a specific model were involved.

select count(ACCIDENT.report_number) from ACCIDENT,PARTICIPATED,CAR where ACCIDENT.report_number=PARTICIPATED.report_number AND PARTICIPATED.Regno=CAR.Regno AND CAR.model='Honda';