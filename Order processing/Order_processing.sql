CREATE DATABASE ORDER_PROCESSING;
USE ORDER_PROCESSING;
create table customer(cust_no int, cname varchar(20), city varchar(20), primary key(cust_no));
create table orders(order_no int, odate date, cust_no int, ord_amt int, primary key(order_no), foreign key(cust_no) references customer(cust_no));
create table item(item_no int, unit_price int, primary key(item_no));
create table order_item(order_no int, item_no int , qty int, foreign key(order_no) references orders(order_no), foreign key(item_no) references item(item_no) on delete set NULL);
create table warehouse(warehouse_no int, city varchar(20), primary key(warehouse_no));
create table shipment(order_no int, warehouse_no int, shit_date date, foreign key(order_no) references orders(order_no), foreign key(warehouse_no) references warehouse(warehouse_no));
show tables;

insert into customer values('1','anish','bangalore');
insert into orders values('100','20-03-21','1','6000');
insert into item values('10','100');
insert into order_item values('100','10','1');
insert into warehouse values('1001','bangalore');
insert into shipment values('100','1001','25-03-21');

-- i. Produce a listing: CUSTNAME, #oforders, AVG_ORDER_AMT, where the middle column is the total numbers of orders by the customer and the last column is the average order amount for that customer.

select C.cname, count(*) as NO_OF_ORDERS, avg(O.ord_amt) as AVG_ORDER_AMT
from customer C, orders O
where (C.cust_no = O.cust_no) group by cname;

-- ii. List the order# for orders that were shipped from all warehouses that the company has in a specific city.

select * from orders where order_no in (
select order_no from shipment where warehouse_no in (
select warehouse_no from warehouse where city='bangalore'));

-- v. Demonstrate how you delete item# 10 from the ITEM table and make that field null in the ORDER_ITEM table.

delete from item where item_no = 10;


