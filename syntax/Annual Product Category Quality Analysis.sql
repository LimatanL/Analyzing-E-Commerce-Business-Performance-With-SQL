-- revenue per tahun
CREATE TABLE rev_by_year AS
	SELECT  
		DATE_PART('year', o.order_purchase_timestamp) AS year_transaction,
		SUM(revenue_per_order) AS revenue
	FROM (
		SELECT 
			order_id, 
			SUM(price+freight_value) AS revenue_per_order
		FROM order_items
		GROUP BY 1
		) subq
	JOIN orders o ON subq.order_id = o.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY 1
	ORDER BY 1;

-- Jumlah cancel order per tahun
CREATE TABLE canceled_order_by_year AS 
	SELECT 
		DATE_PART('year', order_purchase_timestamp) AS year_transaction,
		COUNT(order_id) AS total_canceled_order
	FROM orders
	WHERE order_status = 'canceled'
	GROUP BY 1
	ORDER BY 1;

--top kategori yang menghasilkan revenue terbesar per tahun
CREATE TABLE top_category_revenue_by_year AS
	SELECT 
		year_transaction,
		product_category_name,
		revenue
	FROM (
		SELECT 
			year_transaction,
			product_category_name,
			SUM(price+freight_value) AS revenue,
			RANK () OVER(
				PARTITION BY year_transaction
				ORDER BY SUM(price+freight_value) DESC
			) AS rank_revenue
		FROM order_items AS oid
		JOIN (
			SELECT 
				order_id,
				DATE_PART('year', order_purchase_timestamp) AS year_transaction
			FROM orders
			WHERE order_status = 'delivered'
			) AS orders
		ON oid.order_id = orders.order_id
		JOIN product AS p
		ON oid.product_id = p.product_id
		GROUP BY 1,2
	) AS revenue_category
	WHERE rank_revenue = 1;


-- kategori yang mengalami cancel order terbanyak per tahun
CREATE TABLE top_category_canceled_order_by_year AS
	SELECT 
		year_transaction,
		product_category_name,
		canceled_order
	FROM (
		SELECT 
			year_transaction,
			product_category_name,
			COUNT(oid.order_id) AS canceled_order,
			RANK () OVER(
				PARTITION BY year_transaction
				ORDER BY COUNT(oid.order_id) DESC
			) AS rank_cancel
		FROM order_items AS oid
		JOIN (
			SELECT 
				order_id,
				DATE_PART('year', order_purchase_timestamp) AS year_transaction
			FROM orders
			WHERE order_status ='canceled'
			) AS orders
		ON oid.order_id = orders.order_id
		JOIN product AS p
		ON oid.product_id = p.product_id
		GROUP BY 1,2
	) AS canceled
	WHERE rank_cancel = 1;


-- Join all table
SELECT
	tpy.year_transaction AS year_transaction,
	tpy.revenue AS total_revenue,
	trc.product_category_name AS top_revenue_category,
	trc.revenue AS revenue_by_category,
	tco.total_canceled_order AS total_canceled_order,
	tccoby.product_category_name AS top_canceled_order_category,
	tccoby.canceled_order AS top_canceled_order_by_year
FROM rev_by_year AS tpy
JOIN canceled_order_by_year AS tco ON tpy.year_transaction = tco.year_transaction
JOIN top_category_revenue_by_year AS trc ON tco.year_transaction = trc.year_transaction
JOIN top_category_canceled_order_by_year AS tccoby ON trc.year_transaction = tccoby.year_transaction;