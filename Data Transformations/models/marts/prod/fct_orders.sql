{{config(materialized='table')}}


select
    ORDER_DATE_PK,
    ORDER_PK,
    PRODUCT_PK,
    CUSTOMER_PK,
    STAFF_PK,
    STORE_PK,
    SHIP_DATE_PK,
    processing_speed_in_days,
    item_id,
    quantity,
    unit_price,
    subtotal,
    total_including_discount,
    FACT_LOAD_DATE,
    FACT_RECORD_SOURCE
from {{ref("core_orders")}}
where order_status = 4