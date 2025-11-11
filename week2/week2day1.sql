use classicmodels;

#aliasing columns
select * from customers; 
select customerNumber as Number, city from customers;

#wildcards , like, pattern matching queries
#select customers whose name starts with mini

select * 
from customers 
where customerName LIKE "Mini%";

#ending with
select *
from customers 
where customerName LIKE '%Ltd.';

#in between
select *
from customers 
where customerName LIKE '%nad%';

#matching exactly x characters
select * from customers
where city like "M___d";

#case sensitivity
select * from customers
where city like binary "%v%";

#Agregations
select * from payments;
select sum(amount) as Total from payments;

select count(*) as Total_amounts, sum(amount) as Total, avg(amount) from payments;



#Case statements
select distinct status from orders;

select *, case 
when status = "Shipped" then "Order Completed"
when status = "Resolved" then "Order Completed"
else "Order Pending"
end as OrderStatus 

from orders;


#JOINS inner, full, outer, left , right
#table aliasing
#customers ; name, phone number
# orders ; orderdate, status

select customers.customerName, customers.phone, orders.orderDate, orders.status
from customers
inner join 
orders on customers.customerNumber= orders.customerNumber;

#full outer
#union

select o.orderDate, o.status, c.customerName, c.phone
from orders o 
left join customers c on o.customerNumber = c.customerNumber
union 
select o.orderDate, o.status, c.customerName, c.phone
from orders o
right join customers c on o.customerNumber= c.customerNumber;


#grouping by
# total value of all orders by each customers
#identify core tables; customers 
#orders; ordernumber, customernumber
#orderdetails; ordernumber, priceeach
#join customers to orders, then result to orderdetails

select * from orderdetails limit 5;

select c.customerName as Name, sum(od.quantityOrdered * od.priceEach) as Tota_Order_Valuel
from customers c
join orders o on c.customerNumber=o.customerNumber
join orderdetails od on o.orderNumber=od.orderNumber
group by c.customerName;


select * from payments;
select * from customers;

#calculate average order value
select avg(amount) as avg_order_value from payments;
select customerNumber, customerName from customers 
where customerNumber in
(select customerNumber from payments
group by customerNumber
having sum(amount)> (select avg(amount) as avg_order_value from payments));

#Views; virtual table to store reusable queries
#a view of order summary
#customer, oreder no, date, total value
#customers table, orders table, order details
#orderNumber, date, customer name, total values
create view order_summary as 
select o.orderNumber, o.orderDate, c.customerName, sum(od.quantityOrdered*od.priceEach) as Orders_Total
from orders o
join orderdetails od on o.orderNumber=od.orderNumber
join customers c on o.customerNumber=c.customerNumber
group by o.orderNumber;


#query the view
select * from order_summary
where Orders_Total>15000;

#Functions; user defined
#is a single value
#create function...name(parameters)
#return data type
#xtics; deterministic, non-deterministic, timenow(), customerNumber;total
#begin...
#return value
#end
delimiter //
create function total_payments(cust_id int)
returns decimal(10,2)
deterministic
begin 
declare total decimal(10,2);
select sum(amount)
into total
from payments
where customerNumber=cust_id;
return total;
end;
//
delimiter ;
select customerName, total_payments(customerNumber) as total_payment from customers;


total_payments(103);






