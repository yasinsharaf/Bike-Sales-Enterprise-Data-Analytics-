with hub_brands as ( select * from {{ref("hub_brands")}} ),

sat_brand_details as ( select * from {{ref("sat_brand_details")}} ),

final as (
    select
        hb.BRAND_PK,
        sbd.brand_name
    from
        hub_brands hb
        join sat_brand_details sbd on hb.BRAND_PK = sbd.BRAND_PK
)

select * from final
