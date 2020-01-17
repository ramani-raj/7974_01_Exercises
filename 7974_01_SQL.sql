/* Module 1 - Basic Statements */
/* 1 */
create database training; 

/* 2 */
use training; 
create table demography
(
CustID int PRIMARY KEY auto_increment,
Name varchar(50),
Age int,
Gender varchar(1)
);

/* 3 */  
insert into demography values(1,'John',25,'M');

/* 4 */
insert into demography 
(Name,Age,Gender) 
values 
('Pawan',26,'M'),
('Hema',28,'F');

/* 5 */
insert into demography 
(Name,Gender) 
values 
('Rekha','F');

/* 6 */
select * from demography;

/* 7 */
update demography 
set Age=NULL 
where Name='John';

/* 8 */
select * from demography where Age=NULL;

/* 9 - any one of the following statements will suffice*/
delete from demography;
truncate demography;

/* 10 */
drop table demography;




/* Module 2 - Where clause*/
/* 1 */
select 
account_id, cust_id, avail_balance 
from 
account 
where 
status='ACTIVE' and avail_balance > 2500;

/* 2 - Either of the queries can be used */
select * from account where open_date like '2002%';
select * from account where year(open_date) = '2002';

/* 3 */
select 
account_id, avail_balance,pending_balance 
from 
account 
where 
avail_balance <> pending_balance;

/* 4 */
select 
account_id,product_cd 
from 
account 
where 
account_id in (1,10,23,27);

/* 5 */
select 
account_id,avail_balance 
from 
account 
where 
avail_balance between 100 and 200;




/* Module 3 - Operators and Functions */
/* 1 */
select count(*) from account;

/* 2 */
select * from account limit 2;

/* 3 */
select * from account limit 2,2;

/* 4 */
select 
year(birth_date), month(birth_date), day(birth_date), weekday(birth_date)
from 
individual;

/* 5 */
select substring('Please find the substring in this string',17,9);

/* 6 */
select sign(25.76823);
select round(25.76823);

/* 7 */
select date_add(curdate(), INTERVAL 30 day);

/* 8 */
select 
left(fname,3),
right(lname,3)
from 
individual;

/* 9 */
select 
ucase(fname)
from
individual 
where length(fname)=5;

/* 10 */
select 
max(avail_balance), 
avg(avail_balance)
from
account
where
cust_id=1;




/*Module 4 - Group by */
/* 1 */
select 
cust_id, count(*) as number_of_accounts 
from 
account 
group by 
cust_id;

/* 2 */
select 
cust_id, count(*) as number_of_accounts
from 
account 
group by 
cust_id
having 
count(*) > 2;

/* 3 */
select 
fname, birth_date 
from
individual
order by 
birth_date
desc;

/* 4 */
select 
year(open_date), avg(avail_balance)
from
account
group by 
year(open_date)
having
avg(avail_balance) > 2000
order by 
year(open_date);

/* 5 */
select 
product_cd, max(pending_balance)
from
account
where
product_cd in ('CHK', 'SAV', 'CD')
group by 
product_cd;




/* Module 5 - Joins */
/* 1 */
select 
fname, title, name 
from 
employee join department
on 
employee.dept_id = department.dept_id;

/* 2 */
select 
product_type.name, product.name
from
product_type left join product
on product_type.product_type_cd=product.product_type_cd;

/* 3 */
select 
concat(a.fname,' ',a.lname) as employee_name,
concat(b.fname,' ',b.lname) as superior_name
from
employee a join employee b
on 
a.superior_emp_id = b.emp_id;

/* 4 */
select  
fname,lname
from 
employee
where
superior_emp_id =
(select emp_id from employee
where fname='Susan' and lname='Hawthorne');

/* 5 */
select 
fname,lname
from 
employee
where
emp_id in
(select superior_emp_id from employee
where dept_id=1);


