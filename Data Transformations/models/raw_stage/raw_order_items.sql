with 

source as (

    select 
        *
    from {{ source('Sales', 'Order_Items') }}
    join {{ source('Sales', 'Orders') }} using (order_id)

),

renamed as (

    select
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount,
        order_date

    from source

)

select * from renamed
