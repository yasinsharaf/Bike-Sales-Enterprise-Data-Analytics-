with hub_products as ( select * from {{ref("hub_products")}} ),

sat_product_details as ( select * from {{ref("sat_product_details")}} ),

link_products_brands as ( select * from {{ref("link_products_brands")}} ),

link_products_categories as ( select * from {{ref("link_products_categories")}} ),

hub_brands as ( select * from {{ref("hub_brands")}} ),

final as (
    select
        hp.PRODUCT_PK,
        hb.BRAND_PK,
        lpc.CATEGORY_PK,
        product_name,
        spd.model_year,
        spd.list_price
    from
        hub_products hp 
        join link_products_brands lpb on hp.PRODUCT_PK = lpb.PRODUCT_PK
        join hub_brands hb on lpb.BRAND_PK = hb.BRAND_PK
        join sat_product_details spd on hp.PRODUCT_PK = spd.PRODUCT_PK
        join link_products_categories lpc on hp.PRODUCT_PK = lpc.PRODUCT_PK
)

select * from final
