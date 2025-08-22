--#### SELECT
--1. Write a query that returns everything in the customer table.

SELECT * from customer

--2. Write a query that displays all of the columns and 10 rows from the customer table, sorted by customer_last_name, then customer_first_ name.

SELECT * from customer
order by
customer_last_name,
customer_first_name
limit 10


--#### WHERE
--1. Write a query that returns all customer purchases of product IDs 4 and 9.

SELECT * from customer_purchases
WHERE product_id = 4 or 9

--2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), filtered by vendor IDs between 8 and 10 (inclusive) using either:
	--1.  two conditions using AND
	--2.  one condition using BETWEEN

SELECT *,
	quantity * cost_to_customer_per_qty as price

from customer_purchases
where vendor_id between 8 and 10


--#### CASE
--1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. Using the product table, write a query that outputs the `product_id` and `product_name` columns and add a column called `prod_qty_type_condensed` that displays the word “unit” if the `product_qty_type` is “unit,” and otherwise displays the word “bulk.”

select 
    product_id, 
    product_name,
    case
        when product_qty_type = 'unit' then 'unit'
        else 'bulk'
    end as prod_qty_type_condensed
from product

--2. We want to flag all of the different types of pepper products that are sold at the market. Add a column to the previous query called `pepper_flag` that outputs a 1 if the product_name contains the word “pepper” (regardless of capitalization), and otherwise outputs 0.

select 
    product_id, 
    product_name,
    case
        when product_qty_type = 'unit' then 'unit'
        else 'bulk'
    end as prod_qty_type_condensed,
	case
		when product_name like '%pepper%' then 1
		else 0
	end as pepper_flag
from product;


--#### JOIN
--1. Write a query that `INNER JOIN`s the `vendor` table to the `vendor_booth_assignments` table on the `vendor_id` field they both have in common, and sorts the result by `vendor_name`, then `market_date`.

select 
    v.vendor_id,
    v.vendor_name,
    vba.market_date,
    vba.booth_number
from vendor v
inner join vendor_booth_assignments vba
    on v.vendor_id = vba.vendor_id
order by v.vendor_name, vba.market_date;


--#### AGGREGATE
--1. Write a query that determines how many times each vendor has rented a booth at the farmer’s market by counting the vendor booth assignments per `vendor_id`.

select vendor_id,
	count(*) as booths_rented
from vendor_booth_assignments
group by vendor_id

--2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list of customers for them to give stickers to, sorted by last name, then first name.

select
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    sum(cp.quantity * cp.cost_to_customer_per_qty) as total_cost
from customer_purchases cp
inner join customer c
    on cp.customer_id = c.customer_id
group by
    c.customer_id,
    c.customer_first_name,
    c.customer_last_name
having
    sum(cp.quantity * cp.cost_to_customer_per_qty) > 2000
order by
    c.customer_last_name,
    c.customer_first_name


--#### Temp Table
--1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal
   
create table temp.new_vendor as

select
vendor_id,
vendor_name,
vendor_type,
vendor_owner_first_name,
vendor_owner_last_name

from vendor;

insert into temp.new_vendor
values(10,'Thomass Superfood Store','a Fresh Focused store','Thomas','Rosenthal')

select * from temp.new_vendor