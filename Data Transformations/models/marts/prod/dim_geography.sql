{{config(materialized='table')}}

with staged as (

    select
        concat(street, ', ', city, ', ', state, ' ', zip_code) as address,
        street,
        city,
        state,
        zip_code
    from {{ref("sat_customer_address")}}

    UNION DISTINCT

    select
        concat(street, ', ', city, ', ', state, ' ', zip_code) as address,
        street,
        city,
        state,
        zip_code
    from {{ref("sat_stores_address")}}

),

final as (
    select
        {{hashkey(col_name = 'address')}} AS GEOGRAPHY_PK,
        street,
        city,
        state,
        zip_code
    from staged
)

select * from final