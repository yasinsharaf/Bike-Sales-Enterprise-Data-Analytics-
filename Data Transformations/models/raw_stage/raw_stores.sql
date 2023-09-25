with 

source as (

    select 
        stores.*,
        order_date,
        rank () over (
            partition by store_id
            order by order_date
        ) ranked_date
    from {{ source('Sales', 'Stores') }} stores
    left join {{ source('Sales', 'Orders') }} orders using (store_id)

),

renamed as (

    select
        store_id,
        store_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
