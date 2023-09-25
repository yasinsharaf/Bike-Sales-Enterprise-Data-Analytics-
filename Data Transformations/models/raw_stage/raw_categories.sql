with 

source as (

    select 
        categories.*,
        order_date,
        rank () over (
            partition by category_id
            order by order_date
        ) ranked_date
    from {{ source('Production', 'Categories') }} categories
    left join {{ source('Production', 'Products') }} products using (category_id)
    left join {{ source('Production', 'Stocks') }} stocks using (product_id)
    left join {{ source('Sales', 'Stores') }} stores using (store_id)
    left join {{ source('Sales', 'Orders') }} orders using (store_id)

),

renamed as (

    select
        category_id,
        category_name,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
