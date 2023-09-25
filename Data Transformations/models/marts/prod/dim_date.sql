{{config(materialized='table')}}

with sat_order_details as (
    select order_date from {{ ref("sat_order_details") }}
)

select distinct
    {{hashkey(col_name = 'order_date')}} AS DATE_PK,
    order_date as DATE_NK,
    EXTRACT(DAYOFWEEK from order_date) AS DayOfWeek,
    FORMAT_DATE('%d', order_date) AS DayOfMonth,
    FORMAT_DATE('%A', order_date) AS Weekday,
    EXTRACT(MONTH from order_date) AS Month,
    FORMAT_DATE('%B', order_date) AS MonthName,
    EXTRACT(QUARTER from order_date) AS Quarter,
    EXTRACT(YEAR from order_date) AS Year
from sat_order_details order by order_date ASC


