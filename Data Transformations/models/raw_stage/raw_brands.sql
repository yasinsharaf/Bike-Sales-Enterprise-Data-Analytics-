with 

source as (

    select 
        brands.*,
        order_date,
        rank () over (
            partition by brand_id
            order by order_date
        ) ranked_date
    from {{ source('Production', 'Brands') }} brands
    left join {{ source('Production', 'Products') }} products using (brand_id)
    left join {{ source('Production', 'Stocks') }} stocks using (product_id)
    left join {{ source('Sales', 'Stores') }} stores using (store_id)
    left join {{ source('Sales', 'Orders') }} orders using (store_id)

),

renamed as (

    select
        brand_id,
        brand_name,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
