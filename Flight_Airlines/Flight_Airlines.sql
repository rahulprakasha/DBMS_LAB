create database flight_airlines;
use flight_airlines;
create table flights(
    flno integer not null,
    ffrom varchar(20) not null,
    fto varchar(20) not null,
    distance int not null,
    departs time not null,
    arrives time not null,
    price int not null,
    primary key(flno)
);
create table aircraft(
    aid int not null,
    aname varchar(20) not null,
    cruisingrange int not null,
    primary key(aid)
);
create table employee(
    eid int not null,
    ename varchar(20) not null,
    salary int not null,
    primary key(eid)
);
create table certified(
    eid int not null,
    aid int not null,
    foreign key(eid) REFERENCES employee(eid) on delete cascade on update cascade,
foreign key(aid) references aircraft(aid) on delete cascade on update cascade);
show tables;

 INSERT INTO flights VALUES('7','Bangalore','Frankfurt','17000','12:00:00','06:30:00','99000');
 INSERT INTO aircraft (aid,aname,cruisingrange) values('951','Aircraft03','1000');
 INSERT INTO employee (eid,ename,salary) VALUES('7','Ram','100000');
 INSERT INTO certified (eid,aid) VALUES('1','789');
 select * from certified;
 
-- i. Find the names of aircraft such that all pilots certified to operate them have salaries more than Rs.80,000.

 select distinct aname from aircraft where aid in (select aid from certified where eid in (select eid from employee
 where salary > 80000));

-- ii. For each pilot who is certified for more than three aircrafts, find the eid and the maximum cruising range of the aircraft for which she or he is certified.

select c.eid, max(cruisingrange) from certified c, aircraft a where c.aid = a.aid group by c.eid having count(*) > 3;

-- iii. Find the names of pilots whose salary is less than the price of the cheapest route from Bengaluru to Frankfurt

select e.ename from employee e where exists (select * from certified c where c.eid = e.eid) and e.salary 
< (select min(price) from flights where ffrom = 'Bangalore' and fto = 'Frankfurt');

-- iv. For all aircraft with cruising range over 1000 Kms, find the name of the aircraft and the average salary of
--  all pilots certified for this aircraft.

select a.aname, avg(e.salary) from aircraft a, certified c, employee e where c.aid = a.aid and c.eid = e.eid 
and a.cruisingrange > 1000 group by a.aname;

-- v. Find the names of pilots certified for some Boeing aircraft.

select e.ename from employee e, certified c, aircraft a where a.aname like '%Boeing%' and a.aid = c.aid 
and c.eid = e.eid

-- vi. Find the aids of all aircraft that can be used on routes from Bengaluru to New Delhi.

select aid from aircraft where cruisingrange > (select distance from flights where ffrom = 'Bangalore' 
and fto = 'Delhi');

-- vii.Print the name and salary of every non-pilot whose salary is more than the average salary for pilots.

select e1.ename, e1.salary from employee e1 where e1.salary > (select avg(e.salary) from employee e where e.eid in 
(select eid from certified)) and not exists(select * from certified c where c.eid = e1.eid)

