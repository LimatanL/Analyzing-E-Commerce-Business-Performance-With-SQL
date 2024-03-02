-- METODE PEMBAYARAN YANG PALING SERING DIGUNAKAN
SELECT
    payment_type,
    COUNT(order_id) AS payment_usage_type
FROM
    order_payments
GROUP BY
    1
ORDER BY
    2 DESC;

-- MENGHITUNG PENGGUNAAN METODE PEMBAYARAN TAHUNAN
SELECT
    payment_type,
    SUM(CASE WHEN year = 2016 THEN payment_usage_type ELSE 0 END) AS "2016",
    SUM(CASE WHEN year = 2017 THEN payment_usage_type ELSE 0 END) AS "2017",
    SUM(CASE WHEN year = 2018 THEN payment_usage_type ELSE 0 END) AS "2018",
    SUM(payment_usage_type) AS total_payment_type
FROM
    (SELECT
        DATE_PART('year', o.order_purchase_timestamp) AS year,
        payment_type,
        COUNT(payment_type) AS payment_usage_type
    FROM
        orders AS o
    JOIN
        order_payments AS op ON op.order_id = o.order_id
    GROUP BY
        1, 2
    ) AS sq
GROUP BY
    1
ORDER BY
    2 DESC;
