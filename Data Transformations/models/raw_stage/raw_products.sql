with 

source as (

    select 
        products.*,
        order_date,
        rank () over (
            partition by product_id
            order by order_date
        ) ranked_date
    from {{ source('Production', 'Products') }} products
    left join {{ source('Production', 'Stocks') }} stocks using (product_id)
    left join {{ source('Sales', 'Stores') }} stores using (store_id)
    left join {{ source('Sales', 'Orders') }} orders using (store_id)

),

renamed as (

    select
        product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
