select
  DATE_NK,
  round(sum(total_including_discount),2) as sales
from
  `dbt_yasinsharaf.fct_orders` orders
  join `dbt_yasinsharaf.dim_date` dates on orders.ORDER_DATE_PK = dates.DATE_PK
group by DATE_NK
order by DATE_NK