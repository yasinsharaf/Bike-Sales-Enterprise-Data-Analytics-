with sat_category_details as ( select * from {{ref("sat_category_details")}} ),


final as (
    select
        CATEGORY_PK,
        REGEXP_EXTRACT(category_name, r'\w+') as category_name
    from
        sat_category_details
)

select * from final