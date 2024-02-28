CREATE TABLE customers(
	customer_id VARCHAR,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix INT,
	customer_city VARCHAR,
	customer_state VARCHAR
);
CREATE TABLE geolocation(
	geolocation_zip_code_prefix VARCHAR,
	geolocation_lat VARCHAR,
	geolocation_lng VARCHAR,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR
);
CREATE TABLE order_items(
	order_id VARCHAR,
	order_item_id INT,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
	price FLOAT,
	freight_value FLOAT
);
CREATE TABLE order_payments(
	order_id VARCHAR,
	payment_sequential INT,
	payment_type VARCHAR,
	payment_installments INT,
	payment_value FLOAT
);
CREATE TABLE order_reviews(
	review_id VARCHAR,
	order_id VARCHAR,
	review_score INT,
	review_comment_title VARCHAR,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP WITHOUT TIME ZONE,
	review_answer_timestamps TIMESTAMP WITHOUT TIME ZONE
);
CREATE TABLE orders(
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP WITHOUT TIME ZONE,
	order_approved_at TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_carrier_date TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_customer_date TIMESTAMP WITHOUT TIME ZONE,
	order_estimated_delivery_date TIMESTAMP WITHOUT TIME ZONE
);
CREATE TABLE product(
	num INT,
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_length FLOAT,
	product_description_length FLOAT,
	product_photos_qty FLOAT,
	product_weight_g FLOAT,
	product_length_cm FLOAT,
	product_height_cm FLOAT,
	product_width_cm FLOAT
);
CREATE TABLE sellers(
	seller_id VARCHAR,
	seller_zip_code_prefix VARCHAR,
	seller_city VARCHAR,
	seller_state VARCHAR
);

--Primary Key
ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY(order_id);
ALTER TABLE product ADD CONSTRAINT product_pkey PRIMARY KEY(product_id);
ALTER TABLE sellers ADD CONSTRAINT sellers_pkey PRIMARY KEY(seller_id);
ALTER TABLE customers ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);

--Foreign Key
ALTER TABLE order_items ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY(product_id) REFERENCES product;
ALTER TABLE order_items	ADD FOREIGN KEY(seller_id) REFERENCES sellers;
ALTER TABLE order_payments ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_reviews ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE orders ADD FOREIGN KEY(customer_id) REFERENCES customers;