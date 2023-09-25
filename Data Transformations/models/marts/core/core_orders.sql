with hub_orders as ( select * from {{ref("hub_orders")}} ),

sat_order_details as ( select * from {{ref("sat_order_details")}} ),

link_orders_customers as ( select * from {{ref("link_orders_customers")}} ),

link_orders_staffs as ( select * from {{ref("link_orders_staffs")}} ),

link_orders_stores as ( select * from {{ref("link_orders_stores")}} ),

link_orders_products as ( select * from {{ref("link_orders_products")}} ),

sat_order_product_details as ( select * from {{ref("sat_order_product_details")}} ),

final as (
    select
        ho.order_pk,
        CAST(UPPER(TO_HEX(MD5(NULLIF(UPPER(TRIM(CAST(order_date AS STRING))), '')))) AS STRING) AS order_date_pk,
        CAST(UPPER(TO_HEX(MD5(NULLIF(UPPER(TRIM(CAST(shipped_date AS STRING))), '')))) AS STRING) AS ship_date_pk,
        lop.product_pk,
        loc.customer_pk,
        lostffs.staff_pk,
        lostrs.store_pk,
        sod.order_status,
        extract(day from (shipped_date - order_date)) as processing_speed_in_days,
        sopd.item_id,
        sopd.quantity,
        sopd.list_price as unit_price,
        list_price*quantity as subtotal,
        list_price*quantity - list_price*quantity*discount as total_including_discount,
        sod.LOAD_DATE as fact_load_date,
        sod.RECORD_SOURCE as fact_record_source
    from hub_orders ho
        join sat_order_details sod on ho.order_pk = sod.order_pk
        join link_orders_customers loc on ho.order_pk = loc.order_pk
        join link_orders_staffs lostffs on ho.order_pk = lostffs.order_pk
        join link_orders_stores lostrs on ho.order_pk = lostrs.order_pk
        join link_orders_products lop on ho.order_pk = lop.order_pk
        join sat_order_product_details sopd on lop.order_product_pk = sopd.order_product_pk
)

select * from final