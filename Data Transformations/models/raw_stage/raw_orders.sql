with 

source as (

    select * from {{ source('Sales', 'Orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        order_status,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id

    from source

)

select * from renamed
