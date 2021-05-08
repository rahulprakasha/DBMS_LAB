show databases;
create database Banking;
use Banking;
create table BRANCH(Branch_Name varchar(25) primary key, Branch_City varchar(25), Assets real);
create table BANKACCOUNTS(Acc_no int, Branch_Name varchar(25), Balance real, primary key(Acc_no), foreign key(Branch_Name) references BRANCH(Branch_Name) on delete cascade);
create table BANKCUSTOMER(CustomerName varchar(30), CustomerStreet varchar(30), CustomerCity varchar(30), primary key(CustomerName));
create table DEPOSITER(CustomerName varchar(30), Acc_no Int, primary key(CustomerName, Acc_no), foreign key(CustomerName) references BANKCUSTOMER(CustomerName) on delete cascade, foreign key(Acc_no) references BANKACCOUNTS(Acc_no) on delete cascade);
create table LOAN(LoanNumber int, Branch_Name varchar(30), Amount real, primary key(loanNumber), foreign key(Branch_Name) references BRANCH(Branch_Name) on delete cascade);
show tables; 
insert into BRANCH values('SBI_IND','Delhi','900000');
insert into BANKACCOUNTS values('0004','SBI_MG','11000');
insert into BANKCUSTOMER values('Amit','RT_Nagar','Bombay');
insert into DEPOSITER values('James','0004');
insert into LOAN values('01','SBI_CHM','120000');
select * from BRANCH;

-- Find all the customers who have at least two deposits at the same branch (Ex. ‘SBI_RAJ’) 

select C.CustomerName 
 from BANKCUSTOMER C
 where exists 
 (select D.CustomerName, count(D.CustomerName)
 from DEPOSITER D, BANKACCOUNTS BA
 where
 D.Acc_no = BA.Acc_no AND
 C.CustomerName = D.CustomerName AND
 BA.Branch_Name = 'SBI_RAJ'
 group by D.CustomerName
 having count(D.CustomerName)>=2);
 
 -- Find all the customers who have an account at all the branches located in a specific city (Ex. Delhi).
 
select BC.CustomerName
 from BANKCUSTOMER BC
 where not exists 
 (select Branch_Name from BRANCH
 where Branch_City = 'Delhi'
 -
 (select BA.Branch_Name from
 DEPOSITER D, BANKACCOUNTS BA
 where D.Acc_no = BA.Acc_no and
 BC.CustomerName = D.CustomerName));
 
-- Demonstrate how you delete all account tuples at every branch located in a specific city (Ex. Bomay).
 
delete from BANKACCOUNTS
 where Branch_Name IN (
 select Branch_Name
 from BRANCH
 where Branch_City='Bombay');


