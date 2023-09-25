{{config(materialized = 'table')}}

with hub_stores as ( select * from {{ref("hub_stores")}} ),

sat_stores_address as ( 
    select
        STORE_PK,
        concat(street, ', ', city, ', ', state, ' ', zip_code) as address
    from {{ref("sat_stores_address")}} 
),

sat_stores_profile as ( select * from {{ref("sat_stores_profile")}} ),

sat_stores_contact as ( select * from {{ref("sat_stores_contact")}} ),

link_orders_stores as ( select * from {{ref("link_orders_stores")}} ),

hub_orders as (select * from {{ref("hub_orders")}}),

sat_order_details as (select * from {{ref("sat_order_details")}}),

link_orders_products as (select * from {{ref("link_orders_products")}}),

sat_order_product_details as (select * from {{ref("sat_order_product_details")}}),


staged as (

    select
        hs.STORE_PK,
        {{hashkey(col_name = 'address')}} as GEOGRAPHY_PK,
        ssp.store_name,
        ssc.phone,
        ssc.email,
        min(order_date) as first_order,
        max(order_date) as most_recent_order,
        count(ho.ORDER_PK) as total_orders,
        sum(
            sopd.quantity*sopd.list_price - sopd.quantity*sopd.list_price*sopd.discount
        ) as total_order_value
    from hub_stores hs
        join sat_stores_address ssa on hs.STORE_PK = ssa.STORE_PK
        join sat_stores_profile ssp on hs.STORE_PK = ssp.STORE_PK
        join sat_stores_contact ssc on hs.STORE_PK = ssc.STORE_PK
        join link_orders_stores los on hs.STORE_PK = los.STORE_PK
        join hub_orders ho on los.ORDER_PK = ho.ORDER_PK
        join sat_order_details sod on ho.ORDER_PK = sod.ORDER_PK
        join link_orders_products lop on ho.ORDER_PK = lop.ORDER_PK
        join sat_order_product_details sopd on lop.ORDER_PRODUCT_PK = sopd.ORDER_PRODUCT_PK
    group by 1,2,3,4,5
),


final as (
    select
        STORE_PK,
        GEOGRAPHY_PK,
        store_name,
        phone,
        email,
        first_order,
        most_recent_order,
        total_orders,
        total_order_value
    from staged
)

select * from final