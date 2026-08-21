create database olist;
use olist;
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset_cleaned.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');

 

CREATE TABLE IF NOT EXISTS payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value FLOAT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments cleaned.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    @payment_sequential,
    payment_type,
    @payment_installments,
    @payment_value
)
SET
    payment_sequential = NULLIF(@payment_sequential, ''),
    payment_installments = NULLIF(@payment_installments, ''),
    payment_value = NULLIF(@payment_value, '');
CREATE TABLE IF NOT EXISTS reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset(cleand).csv'
INTO TABLE reviews
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    @review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_score = NULLIF(@review_score, ''),
    review_creation_date = STR_TO_DATE(
        NULLIF(@review_creation_date, ''),
        '%d-%m-%Y %H:%i'
    ),
    review_answer_timestamp = STR_TO_DATE(
        NULLIF(@review_answer_timestamp, ''),
        '%d-%m-%Y %H:%i'
    );
CREATE TABLE IF NOT EXISTS items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Olist order item data set 1.csv'
INTO TABLE items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    @order_item_id,
    product_id,
    seller_id,
    @shipping_limit_date,
    @price,
    @freight_value
)
SET
    order_item_id = NULLIF(@order_item_id, ''),
    shipping_limit_date = STR_TO_DATE(
        NULLIF(@shipping_limit_date, ''),
        '%d-%m-%Y %H:%i'
    ),
    price = NULLIF(@price, ''),
    freight_value = NULLIF(@freight_value, '');
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset_cleaned.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    @customer_zip_code_prefix,
    customer_city,
    customer_state
)
SET
    customer_zip_code_prefix = NULLIF(@customer_zip_code_prefix, '');
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products cleaned dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm,
    @extra_column1,
    @extra_column2
)
SET
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');
CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset(cleaned).csv'

INTO TABLE sellers
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    @seller_zip_code_prefix,
    seller_city,
    seller_state
)
SET
    seller_zip_code_prefix = NULLIF(@seller_zip_code_prefix, '');
CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation cleaned.csv'
INTO TABLE geolocation
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @geolocation_zip_code_prefix,
    @geolocation_lat,
    @geolocation_lng,
    geolocation_city,
    geolocation_state
)
SET
    geolocation_zip_code_prefix = NULLIF(@geolocation_zip_code_prefix, ''),
    geolocation_lat = NULLIF(@geolocation_lat, ''),
    geolocation_lng = NULLIF(@geolocation_lng, '');
CREATE TABLE IF NOT EXISTS category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation_cleaned.csv'
INTO TABLE category_translation
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);

select count(customer_unique_id) as total_customers
from customers;

select count(order_id) as total_orders
from orders;

select sum(price) as total_revenue
from items;

select avg(review_score) as avg_review
from reviews;

select sum(i.price)/count(o.order_id) as avg_order_value
 from items as i
join orders as o 
on o.order_id = i.order_id;

