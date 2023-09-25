with orders as (select * from {{ref("fct_orders")}}),
customers as (select * from {{ref("dim_customers")}}),
geography as (select * from {{ref("dim_geography")}}),
products as (select * from {{ref("dim_products")}}),
categories as (select * from {{ref("dim_categories")}}),
dates as (select * from {{ref("dim_date")}})

{% set quarters = [2,3,4] %}

select
  orders.CUSTOMER_PK,
  round(orders.total_including_discount,2) as sales_amt,
  {{categorical_dummies (col_name = 'state', array = ["NY", "TX"])}},
  {{categorical_dummies (col_name = 'state', array = ["Road", "Mountain", "Electric", "Children", "Cruisers", "Comfort"])}},
  {% for quarter in quarters %}
    case when quarter = {{quarter}} then 1 else 0 end as Qtr{{quarter}} {% if not loop.last %} , {% endif %}
  {% endfor %}

from
  orders
  join customers on orders.CUSTOMER_PK = customers.CUSTOMER_PK
  join geography on customers.GEOGRAPHY_PK = geography.GEOGRAPHY_PK
  join products on orders.PRODUCT_PK = products.PRODUCT_PK
  join categories on products.CATEGORY_PK = categories.CATEGORY_PK
  join dates on orders.ORDER_DATE_PK = dates.DATE_PK