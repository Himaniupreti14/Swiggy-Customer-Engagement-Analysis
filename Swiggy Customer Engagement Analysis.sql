
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');


CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');


CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);



CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;


---1 what is the total amount each customer spent on Swiggy?

select s.userid, sum (p.price) as total_amount from sales as s  
join product p 
on s.product_id = p.product_id
group by s.userid


---2 How many days has each customer visited/ordererd product ?

Select distinct userid , count (created_date) as count from sales
group by userid 


---3 What was the first product purchased by each customer?

with firstproduct as (
select userid, created_date,p.product_name, ROW_NUMBER() over(partition by userid order by created_date) as rnk from sales s
join product p 
on s.product_id = p.product_id )
select fp.userid,fp.created_date, fp.product_name
 from firstproduct fp
 where rnk = 1
 


---4 What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT TOP 1
    CAST(p.product_name AS VARCHAR(MAX)) AS product_name,
    COUNT(s.product_id) AS purchase_count
FROM 
    sales s
JOIN 
    product p ON s.product_id = p.product_id
GROUP BY 
    CAST(p.product_name AS VARCHAR(MAX))
ORDER BY 
    purchase_count DESC;



----5 Which item was purchased first by customer after they become a gold member?

with Firstpurchase as (
select s.userid, s.created_date, s.product_id, g.gold_signup_date, 
row_number() over(partition by s.userid order by created_date) rnk from sales s
join goldusers_signup g on s.userid = g.userid
and s.created_date > g.gold_signup_date)

select f.userid, f.created_date, f.product_id,f.gold_signup_date, f.rnk
from Firstpurchase f 
where f.rnk  =1





--6 Which item was purchased just before the customer become a member?

with purchseditem as (
select s.userid,s.created_date, row_number() over(partition by s.userid order by created_date desc) rnk from sales s 
join goldusers_signup g on s.userid = g.userid and s.created_date <= g.gold_signup_date)

select p.userid, p.created_date,p.rnk from purchseditem p 
where p.rnk = 1



---7  What is the total orders and amount spent for each member before they become a member?

with customersales as(
select s.userid, s.created_date, p.price, row_number() over( partition by s.userid order by created_date desc) rnk from sales s
join goldusers_signup g on s.userid = g.userid 
join product p on s.product_id = p.product_id and s.created_date < g.gold_signup_date) 

select c.userid, count(c.created_date)as T_orders, sum(c.price) as T_amt from customersales c
group by c.userid
 



 --8 Rank all the transactions of the customers

select *, rank() over( partition by userid order by created_date ) as rnk from sales 




 ----9 Which users are the most active (made the most purchases)?

 SELECT TOP 5
    userid,
    COUNT(*) AS purchase_count
FROM 
    sales
GROUP BY 
    userid
ORDER BY 
    purchase_count DESC




----10 Rank transactions directly and mark non-gold member transactions as 'NA'
SELECT 
    s.userid,
    s.created_date,
    p.product_id,
    p.product_name,
    p.price,
    CASE 
        WHEN s.created_date >= g.gold_signup_date THEN 
            CAST(ROW_NUMBER() OVER (PARTITION BY s.userid ORDER BY s.created_date) AS VARCHAR)
        ELSE 'NA'
    END AS transaction_rank
FROM 
    sales s
JOIN 
    product p ON s.product_id = p.product_id
LEFT JOIN 
    goldusers_signup g ON s.userid = g.userid
ORDER BY 
    s.userid, s.created_date;




----11 Calculate the month over month sales growth percentage for each product.

WITH monthly_sales AS (
    SELECT 
        s.product_id, 
        FORMAT(s.created_date, 'yyyy-MM') AS month, 
        SUM(p.price) AS total_sales
    FROM 
        sales s
    JOIN 
        product p ON s.product_id = p.product_id
    GROUP BY 
        s.product_id, FORMAT(s.created_date, 'yyyy-MM')
),
sales_growth AS (
    SELECT 
        ms.product_id, 
        ms.month, 
        ms.total_sales,
        LAG(ms.total_sales) OVER (PARTITION BY ms.product_id ORDER BY ms.month) AS previous_month_sales
    FROM 
        monthly_sales ms
)
SELECT 
    sg.product_id, 
    sg.month, 
    sg.total_sales, 
    sg.previous_month_sales,
    CASE 
        WHEN sg.previous_month_sales IS NULL THEN NULL
        WHEN sg.previous_month_sales = 0 THEN NULL
        ELSE ((sg.total_sales - sg.previous_month_sales) / sg.previous_month_sales) * 100 
    END AS growth_percentage
FROM 
    sales_growth sg
ORDER BY 
    sg.product_id, sg.month;






----12 Gold vs Non-Gold retention.

-- Step 1: Identify Gold and Non-Gold Members
WITH user_status AS (
    SELECT 
        u.userid,
        CASE 
            WHEN g.userid IS NOT NULL THEN 'Gold'
            ELSE 'Non-Gold'
        END AS membership_status
    FROM 
        users u
    LEFT JOIN 
        goldusers_signup g ON u.userid = g.userid
),

-- Step 2: Calculate Repeat Purchases
user_purchase_counts AS (
    SELECT 
        s.userid, 
        COUNT(*) AS purchase_count
    FROM 
        sales s
    GROUP BY 
        s.userid
),

-- Step 3: Determine Repeat Purchasers
repeat_purchasers AS (
    SELECT 
        u.userid,
        u.membership_status,
        CASE 
            WHEN upc.purchase_count > 1 THEN 1
            ELSE 0
        END AS is_repeat_purchaser
    FROM 
        user_status u
    LEFT JOIN 
        user_purchase_counts upc ON u.userid = upc.userid
),

-- Step 4: Calculate Retention Rates
retention_rates AS (
    SELECT 
        membership_status,
        COUNT(userid) AS total_users,
        SUM(is_repeat_purchaser) AS repeat_purchasers,
        (SUM(is_repeat_purchaser) * 1.0 / COUNT(userid)) * 100 AS retention_rate
    FROM 
        repeat_purchasers
    GROUP BY 
        membership_status
)

-- Final Result
SELECT 
    membership_status,
    total_users,
    repeat_purchasers,
    retention_rate
FROM 
    retention_rates
ORDER BY 
    membership_status;







-- 13 Calculate MoM Revenue for Gold vs Non-Gold Members
WITH user_status AS (
    SELECT 
        u.userid,
        CASE 
            WHEN g.userid IS NOT NULL THEN 'Gold'
            ELSE 'Non-Gold'
        END AS membership_status
    FROM 
        users u
    LEFT JOIN 
        goldusers_signup g ON u.userid = g.userid
),
monthly_revenue AS (
    SELECT 
        u.membership_status,
        FORMAT(s.created_date, 'yyyy-MM') AS month,
        SUM(p.price) AS total_revenue
    FROM 
        sales s
    JOIN 
        product p ON s.product_id = p.product_id
    JOIN 
        user_status u ON s.userid = u.userid
    GROUP BY 
        u.membership_status, FORMAT(s.created_date, 'yyyy-MM')
),
revenue_mom AS (
    SELECT 
        membership_status,
        month,
        total_revenue,
        LAG(total_revenue) OVER (PARTITION BY membership_status ORDER BY month) AS prev_revenue
    FROM 
        monthly_revenue
)
SELECT 
    membership_status,
    month,
    total_revenue,
    prev_revenue,
    CASE 
        WHEN prev_revenue IS NULL THEN NULL
        ELSE ((total_revenue - prev_revenue) * 1.0 / prev_revenue) * 100
    END AS mom_revenue_change_percentage
FROM 
    revenue_mom
ORDER BY 
    membership_status, month;


----14 How many days does 75 percentile users take to buy a gold membership post signup?

	WITH user_gold_timing AS (
    SELECT 
        u.userid,
        DATEDIFF(day, u.signup_date, g.gold_signup_date) AS days_to_gold
    FROM 
        users u
    JOIN 
        goldusers_signup g ON u.userid = g.userid
),
percentile_75 AS (
    SELECT 
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY days_to_gold) 
        OVER () AS pct_75_days_to_gold
    FROM 
        user_gold_timing
)

SELECT 
    DISTINCT pct_75_days_to_gold
FROM 
    percentile_75;
