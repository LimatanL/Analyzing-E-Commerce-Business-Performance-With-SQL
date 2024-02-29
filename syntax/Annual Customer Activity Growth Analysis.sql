-- Rata-rata Monthly Active User (MAU) per tahun
WITH cnt_mau AS (
    SELECT
        year,
        ROUND(AVG(total_cust), 0) AS avg_mau
    FROM (
        SELECT
            DATE_PART('year', o.order_purchase_timestamp) AS year,
            DATE_PART('month', o.order_purchase_timestamp) AS month,
            COUNT(DISTINCT c.customer_unique_id) AS total_cust
        FROM
            orders O
        JOIN customers c ON c.customer_id = o.customer_id
        GROUP BY
            1,
            2
    ) a
    GROUP BY
        1
),

-- Total customer baru per tahun
new_cust AS (
    SELECT
        DATE_PART('year', first_order) AS year,
        COUNT(customer_unique_id) AS new_customers
    FROM (
        SELECT
            customer_unique_id,
            MIN(o.order_purchase_timestamp) AS first_order
        FROM
            orders o
        JOIN customers c ON o.customer_id = c.customer_id
        GROUP BY
            1
    ) a
    GROUP BY
        1
    ORDER BY
        1
),

-- Jumlah customer yang melakukan repeat order per tahun
repeat_ord AS (
    SELECT
        year,
        COUNT(total_customer) AS repeat_cust_ord
    FROM (
        SELECT
            DATE_PART('year', o.order_purchase_timestamp) AS year,
            c.customer_unique_id,
            COUNT(c.customer_unique_id) AS total_customer,
            COUNT(o.order_id) AS total_order
        FROM
            orders o
        JOIN customers c ON c.customer_id = o.customer_id
        GROUP BY
            1,
            2
        HAVING
            COUNT(order_id) > 1
    ) a
    GROUP BY
        1
    ORDER BY
        1
),

-- Rata-rata frekuensi order untuk setiap tahun
avg_ord AS (
    SELECT
        year,
        ROUND(AVG(total_order), 3) AS avg_freq_order
    FROM (
        SELECT
            DATE_PART('year', o.order_purchase_timestamp) AS year,
            c.customer_unique_id,
            COUNT(DISTINCT o.order_id) AS total_order
        FROM
            orders o
        JOIN customers c ON o.customer_id = c.customer_id
        GROUP BY
            1,
            2
    ) a
    GROUP BY
        1
)

SELECT
    cm.year,
    cm.avg_mau,
    nc.new_customers,
    ro.repeat_cust_ord,
    ao.avg_freq_order
from cnt_mau cm 
join new_cust nc on cm.year=nc.year
left join repeat_ord ro on cm.year=ro.year
left join avg_ord ao on cm.year=ao.year;