#daily sales
select
  DATE_NK,
  round(sum(total_including_discount),2) as sales
from
  `dbt_yasinsharaf.fct_orders` orders
  join `dbt_yasinsharaf.dim_date` dates on orders.ORDER_DATE_PK = dates.DATE_PK
group by DATE_NK
order by DATE_NK

#weekly sales
SELECT 
  format_date('%Y%W', DATE_NK) as week, 
  round(sum(sales_amt),2) as sales 
FROM `digital-yeti-388601.dbt_yasinsharaf.int_regression` 
GROUP BY week 
ORDER BY week