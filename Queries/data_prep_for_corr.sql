SELECT 
  date_nk,
  total_including_discount,
  Month,
  Quarter,
  case
    when state = 'CA' then 1
    when state = 'NY' then 2
    when state = 'TX' then 3
  end as state,
  case
    when state = 'CA' then 39.34
    when state = 'NY' then 28.29
    when state = 'TX' then 8.43
  end as population_2017,
  case
    when state = 'CA' then 253.9
    when state = 'NY' then 414.7
    when state = 'TX' then 108.4
  end as population_density,
  case
    when state = 'CA' then 840
    when state = 'NY' then 539
    when state = 'TX' then 797
  end as cars_per_capita
FROM `digital-yeti-388601.dbt_yasinsharaf.dim_geography` geo
join `dbt_yasinsharaf.dim_customers` cust on geo.GEOGRAPHY_PK = cust.GEOGRAPHY_PK
join `dbt_yasinsharaf.fct_orders` orders on cust.CUSTOMER_PK = orders.CUSTOMER_PK
join `dbt_yasinsharaf.dim_date`orderdate on orders.ORDER_DATE_PK = orderdate.DATE_PK