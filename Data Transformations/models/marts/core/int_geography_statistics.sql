with fct_orders as (select * from {{ref("fct_orders")}}),

dim_customers as (select * from {{ref("dim_customers")}}),

dim_geography as (select * from {{ref("dim_geography")}})



select
    ORDER_PK,
    state,
    city,
    zip_code,
    amount
from dim_geography dg
    join dim_customers dc on dg.GEOGRAPHY_PK = dc.GEOGRAPHY_PK
    join fct_orders fo on dc.CUSTOMER_PK = fo.CUSTOMER_PK
    

