mysql> CREATE DATABASE sales_analysis;
Query OK, 1 row affected (0.14 sec)

mysql> USE sales_analysis;
Database changed
mysql> CREATE TABLE orders (
    ->     order_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     order_date DATE,
    ->     amount DECIMAL(10,2),
    ->     product_id INT
    -> );
Query OK, 0 rows affected (0.19 sec)

mysql> ^C
mysql> INSERT INTO orders (order_date, amount, product_id) VALUES
    -> ('2024-01-05', 250.00, 101),
    -> ('2024-01-15', 180.50, 102),
    -> ('2024-01-28', 320.00, 103),
    ->
    -> ('2024-02-03', 150.00, 101),
    -> ('2024-02-10', 400.00, 104),
    -> ('2024-02-25', 210.75, 102),
    ->
    -> ('2024-03-01', 500.00, 105),
    -> ('2024-03-12', 275.25, 103),
    -> ('2024-03-20', 350.00, 101),
    ->
    -> ('2024-04-05', 420.00, 104),
    -> ('2024-04-18', 310.50, 102),
    ->
    -> ('2024-05-02', 600.00, 105),
    -> ('2024-05-15', 450.00, 103),
    -> ('2024-05-28', 520.00, 104);
Query OK, 14 rows affected (0.04 sec)
Records: 14  Duplicates: 0  Warnings: 0

mysql> -- Step 1: Aggregate revenue and order volume per month
mysql> SELECT
    ->     YEAR(order_date) AS year,
    ->     MONTH(order_date) AS month,
    ->     COUNT(DISTINCT order_id) AS total_orders,
    ->     SUM(amount) AS total_revenue
    -> FROM
    ->     orders
    -> GROUP BY
    ->     YEAR(order_date),
    ->     MONTH(order_date)
    -> ORDER BY
    ->     YEAR(order_date),
    ->     MONTH(order_date);
+------+-------+--------------+---------------+
| year | month | total_orders | total_revenue |
+------+-------+--------------+---------------+
| 2024 |     1 |            3 |        750.50 |
| 2024 |     2 |            3 |        760.75 |
| 2024 |     3 |            3 |       1125.25 |
| 2024 |     4 |            2 |        730.50 |
| 2024 |     5 |            3 |       1570.00 |
+------+-------+--------------+---------------+
5 rows in set (0.02 sec)

mysql> -- a. Extract month from order_date
mysql> SELECT
    ->     order_id,
    ->     order_date,
    ->     EXTRACT(MONTH FROM order_date) AS order_month
    -> FROM orders;
+----------+------------+-------------+
| order_id | order_date | order_month |
+----------+------------+-------------+
|        1 | 2024-01-05 |           1 |
|        2 | 2024-01-15 |           1 |
|        3 | 2024-01-28 |           1 |
|        4 | 2024-02-03 |           2 |
|        5 | 2024-02-10 |           2 |
|        6 | 2024-02-25 |           2 |
|        7 | 2024-03-01 |           3 |
|        8 | 2024-03-12 |           3 |
|        9 | 2024-03-20 |           3 |
|       10 | 2024-04-05 |           4 |
|       11 | 2024-04-18 |           4 |
|       12 | 2024-05-02 |           5 |
|       13 | 2024-05-15 |           5 |
|       14 | 2024-05-28 |           5 |
+----------+------------+-------------+
14 rows in set (0.00 sec)

mysql> -- b. Extract year from order_date
mysql> SELECT
    ->     order_id,
    ->     order_date,
    ->     EXTRACT(YEAR FROM order_date) AS order_year
    -> FROM orders;
+----------+------------+------------+
| order_id | order_date | order_year |
+----------+------------+------------+
|        1 | 2024-01-05 |       2024 |
|        2 | 2024-01-15 |       2024 |
|        3 | 2024-01-28 |       2024 |
|        4 | 2024-02-03 |       2024 |
|        5 | 2024-02-10 |       2024 |
|        6 | 2024-02-25 |       2024 |
|        7 | 2024-03-01 |       2024 |
|        8 | 2024-03-12 |       2024 |
|        9 | 2024-03-20 |       2024 |
|       10 | 2024-04-05 |       2024 |
|       11 | 2024-04-18 |       2024 |
|       12 | 2024-05-02 |       2024 |
|       13 | 2024-05-15 |       2024 |
|       14 | 2024-05-28 |       2024 |
+----------+------------+------------+
14 rows in set (0.00 sec)

mysql> -- c. Group orders by year and month
mysql> SELECT
    ->     EXTRACT(YEAR FROM order_date) AS year,
    ->     EXTRACT(MONTH FROM order_date) AS month,
    ->     COUNT(*) AS orders_count
    -> FROM orders
    -> GROUP BY year, month;
+------+-------+--------------+
| year | month | orders_count |
+------+-------+--------------+
| 2024 |     1 |            3 |
| 2024 |     2 |            3 |
| 2024 |     3 |            3 |
| 2024 |     4 |            2 |
| 2024 |     5 |            3 |
+------+-------+--------------+
5 rows in set (0.00 sec)

mysql> -- d. Sum revenue for each month
mysql> SELECT
    ->     EXTRACT(YEAR FROM order_date) AS year,
    ->     EXTRACT(MONTH FROM order_date) AS month,
    ->     SUM(amount) AS total_revenue
    -> FROM orders
    -> GROUP BY year, month;
+------+-------+---------------+
| year | month | total_revenue |
+------+-------+---------------+
| 2024 |     1 |        750.50 |
| 2024 |     2 |        760.75 |
| 2024 |     3 |       1125.25 |
| 2024 |     4 |        730.50 |
| 2024 |     5 |       1570.00 |
+------+-------+---------------+
5 rows in set (0.00 sec)

mysql> -- e. Total orders & total revenue per month
mysql> SELECT
    ->     EXTRACT(YEAR FROM order_date) AS year,
    ->     EXTRACT(MONTH FROM order_date) AS month,
    ->     COUNT(DISTINCT order_id) AS total_orders,
    ->     SUM(amount) AS total_revenue
    -> FROM orders
    -> GROUP BY year, month;
+------+-------+--------------+---------------+
| year | month | total_orders | total_revenue |
+------+-------+--------------+---------------+
| 2024 |     1 |            3 |        750.50 |
| 2024 |     2 |            3 |        760.75 |
| 2024 |     3 |            3 |       1125.25 |
| 2024 |     4 |            2 |        730.50 |
| 2024 |     5 |            3 |       1570.00 |
+------+-------+--------------+---------------+
5 rows in set (0.00 sec)

mysql> -- f. Sort by year/month and limit to 12 months
mysql> SELECT
    ->     EXTRACT(YEAR FROM order_date) AS year,
    ->     EXTRACT(MONTH FROM order_date) AS month,
    ->     COUNT(DISTINCT order_id) AS total_orders,
    ->     SUM(amount) AS total_revenue
    -> FROM orders
    -> GROUP BY year, month
    -> ORDER BY year, month
    -> LIMIT 12;
+------+-------+--------------+---------------+
| year | month | total_orders | total_revenue |
+------+-------+--------------+---------------+
| 2024 |     1 |            3 |        750.50 |
| 2024 |     2 |            3 |        760.75 |
| 2024 |     3 |            3 |       1125.25 |
| 2024 |     4 |            2 |        730.50 |
| 2024 |     5 |            3 |       1570.00 |
+------+-------+--------------+---------------+
5 rows in set (0.00 sec)

mysql> SELECT
    ->     DATE_FORMAT(MIN(order_date), '%b %Y') AS month_year,  
    ->     COUNT(DISTINCT order_id) AS total_orders,
    ->     SUM(amount) AS total_revenue
    -> FROM orders
    -> GROUP BY YEAR(order_date), MONTH(order_date)
    -> ORDER BY YEAR(order_date), MONTH(order_date);
+------------+--------------+---------------+
| month_year | total_orders | total_revenue |
+------------+--------------+---------------+
| Jan 2024   |            3 |        750.50 |
| Feb 2024   |            3 |        760.75 |
| Mar 2024   |            3 |       1125.25 |
| Apr 2024   |            2 |        730.50 |
| May 2024   |            3 |       1570.00 |
+------------+--------------+---------------+
5 rows in set (0.01 sec)

mysql>
