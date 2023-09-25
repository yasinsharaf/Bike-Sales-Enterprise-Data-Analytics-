{%- macro categorical_dummies (col_name , value, array = []) -%}
    {%- for value in array %}
        case when {{col_name}} = '{{value}}' then 1 else 0 end as {{value}} {% if not loop.last -%} , {% endif %}
    {%- endfor -%}
{%- endmacro -%}