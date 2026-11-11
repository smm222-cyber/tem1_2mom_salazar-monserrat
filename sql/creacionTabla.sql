
CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

DROP TABLE IF EXISTS superstore_raw;
CREATE TABLE superstore_raw (
  row_id STRING,
  order_id STRING,
  order_date STRING,
  ship_date STRING,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales STRING,
  quantity STRING,
  discount STRING,
  profit STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
STORED AS TEXTFILE;

DROP TABLE IF EXISTS superstore;
CREATE TABLE superstore (
  row_id BIGINT,
  order_id STRING,
  order_date STRING,
  ship_date STRING,
  ship_mode STRING,
  customer_id STRING,
  customer_name STRING,
  segment STRING,
  country STRING,
  city STRING,
  state STRING,
  postal_code STRING,
  region STRING,
  product_id STRING,
  category STRING,
  sub_category STRING,
  product_name STRING,
  sales DOUBLE,
  quantity INT,
  discount DOUBLE,
  profit DOUBLE
)
STORED AS ORC;

LOAD DATA INPATH '/user/hive/warehouse/superstore.csv'
INTO TABLE superstore_raw;

INSERT INTO TABLE superstore
SELECT
  CAST(row_id AS BIGINT),
  order_id,
  order_date,
  ship_date,
  ship_mode,
  customer_id,
  customer_name,
  segment,
  country,
  city,
  state,
  postal_code,
  region,
  product_id,
  category,
  sub_category,
  product_name,
  CAST(sales AS DOUBLE),
  CAST(quantity AS INT),
  CAST(discount AS DOUBLE),
  CAST(profit AS DOUBLE)
FROM superstore_raw
WHERE row_id <> 'Row ID';

SELECT COUNT(*) AS total_rows FROM superstore;
