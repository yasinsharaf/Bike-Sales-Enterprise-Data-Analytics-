with 

source as (

    select
        *,
        rank () over (
            partition by customer_id
            order by order_date
        ) ranked_date
    from {{ source('Sales', 'Customers') }} 
        join {{source('Sales','Orders')}} using (customer_id)

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code,
        order_date

    from source
    where ranked_date = 1

)

select * from renamed
