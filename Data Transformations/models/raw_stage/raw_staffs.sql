with 

source as (

    select 
        staffs.*,
        order_date,
        rank () over (
            partition by staff_id
            order by order_date
        ) ranked_date
    from {{ source('Sales', 'Staffs') }} staffs
    left join {{ source('Sales', 'Orders') }} orders using (staff_id)
),

renamed as (

    select
        staff_id,
        first_name,
        last_name,
        email,
        phone,
        active,
        store_id,
        manager_id,
        order_date as earliest_order_date

    from source
    where ranked_date = 1

)

select * from renamed
