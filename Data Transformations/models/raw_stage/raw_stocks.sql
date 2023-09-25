with 

source as (

    select 
        stocks.*,
        order_date,
        rank () over (
            partition by store_id
            order by order_date
        ) ranked_date
    from {{ source('Production', 'Stocks') }} stocks
    left join {{ source('Sales', 'Stores') }} stores using (store_id)
    left join {{ source('Sales', 'Orders') }} orders using (store_id)

),

renamed as (

    select
        store_id,
        product_id,
        quantity,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
