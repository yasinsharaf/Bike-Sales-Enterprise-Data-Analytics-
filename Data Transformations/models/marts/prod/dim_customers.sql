{{config(materialized = 'table')}}


with hub_customer as (select * from {{ref("hub_customer")}}),

sat_customer_contact as (select * from {{ref("sat_customer_contact")}}),

sat_customer_address as (
    select
        CUSTOMER_PK,
        concat(street, ', ', city, ', ', state, ' ', zip_code) as address
    from {{ref("sat_customer_address")}}
),

sat_customer_profile as (select * from {{ref("sat_customer_profile")}}),

link_orders_customers as (select * from {{ref("link_orders_customers")}}),

hub_orders as (select * from {{ref("hub_orders")}}),

sat_order_details as (select * from {{ref("sat_order_details")}}),

link_orders_products as (select * from {{ref("link_orders_products")}}),

sat_order_product_details as (select * from {{ref("sat_order_product_details")}}),

staged as (

    select
        hc.CUSTOMER_PK,
        scp.first_name,
        scp.last_name,
        scc.phone,
        scc.email,
        {{hashkey(col_name = 'address')}} as GEOGRAPHY_PK,
        min(order_date) as first_order,
        max(order_date) as most_recent_order,
        count(ho.ORDER_PK) as lifetime_orders,
        sum(
            sopd.quantity*sopd.list_price - sopd.quantity*sopd.list_price*sopd.discount
        ) as lifetime_value
    from hub_customer hc
        join sat_customer_contact scc on hc.CUSTOMER_PK = scc.CUSTOMER_PK
        join sat_customer_address sca on scc.CUSTOMER_PK = sca.CUSTOMER_PK
        join sat_customer_profile scp on sca.CUSTOMER_PK = scp.CUSTOMER_PK
        join link_orders_customers loc on scp.CUSTOMER_PK = loc.CUSTOMER_PK
        join hub_orders ho on loc.ORDER_PK = ho.ORDER_PK
        join sat_order_details sod on ho.ORDER_PK = sod.ORDER_PK
        join link_orders_products lop on ho.ORDER_PK = lop.ORDER_PK
        join sat_order_product_details sopd on lop.ORDER_PRODUCT_PK = sopd.ORDER_PRODUCT_PK
    group by 1,2,3,4,5,6

),

final as (

    select
        CUSTOMER_PK,
        GEOGRAPHY_PK,
        first_name,
        last_name,
        phone,
        email,
        first_order,
        most_recent_order,
        lifetime_orders,
        lifetime_value
    from staged
)

select * from final