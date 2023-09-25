{%- macro pivot_columns(col_name , value, array = []) -%}
    {%- for value in array %}
        round(sum (case when {{col_name}} = '{{value}}' then amount else 0 end),2) as {{value}}_amount {% if not loop.last -%} , {% endif %}
    {%- endfor -%}
{%- endmacro -%}