with orders as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`fct_orders`),
customers as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_customers`),
geography as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_geography`),
products as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_products`),
categories as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_categories`),
dates as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_date`),
brands as (select * from `digital-yeti-388601`.`dbt_yasinsharaf`.`dim_brands`)



select
  order_pk,
  round(orders.total_including_discount,2) as sales_amt,
  
        case when state = 'NY' then 1 else 0 end as NY , 
        case when state = 'TX' then 1 else 0 end as TX ,
  
        case when category_name = 'Road' then 1 else 0 end as Road , 
        case when category_name = 'Mountain' then 1 else 0 end as Mountain , 
        case when category_name = 'Electric' then 1 else 0 end as Electric , 
        case when category_name = 'Children' then 1 else 0 end as Children , 
        case when category_name = 'Cruisers' then 1 else 0 end as Cruisers , 
        case when category_name = 'Comfort' then 1 else 0 end as Comfort ,

        case when brand_name = 'Trek' then 1 else 0 end as Trek , 
        case when brand_name = 'Electra' then 1 else 0 end as Electra , 
        case when brand_name = 'Surly' then 1 else 0 end as Surly , 
        case when brand_name = 'Sun Bicycles' then 1 else 0 end as Sun_Bicycles , 
        case when brand_name = 'Haro' then 1 else 0 end as Haro , 
        case when brand_name = 'Heller' then 1 else 0 end as Heller , 
        case when brand_name = 'Pure Cycles' then 1 else 0 end as Pure_Cycles , 
        case when brand_name = 'Ritchey' then 1 else 0 end as Ritchey ,
  
        case when quarter = 2 then 1 else 0 end as Qtr2  ,
        case when quarter = 3 then 1 else 0 end as Qtr3  , 
        case when quarter = 4 then 1 else 0 end as Qtr4 
  

from
  orders
  join customers on orders.CUSTOMER_PK = customers.CUSTOMER_PK
  join geography on customers.GEOGRAPHY_PK = geography.GEOGRAPHY_PK
  join products on orders.PRODUCT_PK = products.PRODUCT_PK
  join categories on products.CATEGORY_PK = categories.CATEGORY_PK
  join dates on orders.ORDER_DATE_PK = dates.DATE_PK
  join brands on products.BRAND_PK = brands.BRAND_PK