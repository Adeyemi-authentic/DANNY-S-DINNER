create database danny_dinny;
use danny_dinny;
create table sales
(
customer_id varchar(2) not null ,order_date date ,product_id int);
drop table sales;

insert into sales(customer_id,order_date,product_id)
values
('Aa','2021-01-01',1),
('Aa','2021-01-01',2),
('Aa','2021-01-07',3),
('Aa','2021-01-10',3),
('Aa','2021-01-11',3),
('Aa','2021-01-11',3),
('Bb','2021-01-02',2),
('Bb','2021-01-02',2),
('Bb','2021-01-04',1),
('Bb','2021-01-11',1),
('Bb','2021-01-16',3),
('Bb','2021-02-01',3),
('Ca','2021-01-01',3),
('Ca','2021-01-02',3),
('Ca','2021-01-07',3);


create table menu(
product_id int ,product_name varchar(5),price int );

insert into menu(product_id,product_name,price)
values
    (1,'sushi',10),
    (2,'curry',15),
    (3,'ramen',12);
    
create table members(customer_id varchar(2)not null,join_date date);
insert into members(customer_id,join_date)
values
('AA','2021-01-07'),
('BA','2021-01-09');

use danny_dinny;
show tables;
select*from sales;
select*from menu;

-- 1.what was the first item purchased by each customer in the menu --
with customer_purchase as (select customer_id, min(order_date) as customer_purchase_date 
from sales 
group by customer_id
) 

   select cp.customer_id,cp.customer_purchase_date,m.product_name from
   customer_purchase cp join sales s 
   on cp.customer_id=s.customer_id and cp.customer_purchase_date=s.order_date
   join menu m on m.product_id=s.product_id;

-- 2.what is the total amount each custome spent at the restaurant --
select s.customer_id, sum(m.price) from sales s
join menu m on s.product_id=m.product_id
group by customer_id;


-- 3.how many days each customer visited the restaurant--
select s.customer_id,count(distinct order_date) as days_visited
from sales s
group by customer_id;



-- 4.what is the most purchased item and how many times was it purchased--
select  product_name, count(*) as purchased 
from sales join menu on sales.product_id=menu.product_id
group by product_name;

select*from members;

-- 5. what is the total item and amount bought by each member before they became members 
select s.customer_id,count(*) as total_item,sum(m.price) as total_spent
from sales s
join menu m on s.product_id=m.product_id
join members mb on s.customer_id=mb.customer_id
where s.order_date<mb.join_date
group by s.customer_id; 

-- 6. What was purchased just before the customer became a  member. 
select s.customer_id , max(s.order_date) as last_purchase
from sales s 
join members mb on s.customer_id=mb.customer_id
where s.order_date<mb.join_date
group by s.customer_id