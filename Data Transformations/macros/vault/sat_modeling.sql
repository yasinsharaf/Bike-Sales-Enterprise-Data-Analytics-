{% macro sat_id(table_name, pk) -%}
    row_number() over (order by {{pk}}) as sat_{{table_name}}_id
{%- endmacro %}

{% macro sat_datetime(table_name) -%}
    timestamp(datetime(current_timestamp(), 'America/Los_Angeles')) as sat_{{table_name}}_date_time
{%- endmacro %}

{% macro sat_rec_source(table_name, source_id) -%}
    coalesce(NULL, {{source_id}}) AS sat_{{table_name}}_rec_source,
{%- endmacro %}

{% macro sat_detail(col_name,table_name) -%}
    {{col_name}} AS sat_{{table_name}}_{{col_name}}
{%- endmacro %}