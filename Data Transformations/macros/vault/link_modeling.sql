{% macro link_id(table_name, date_time_col) -%}
    row_number() over (order by {{date_time_col}}) as link_{{table_name}}_id
{%- endmacro %}

{% macro link_datetime(table_name) -%}
    timestamp(datetime(current_timestamp(), 'America/Los_Angeles')) as link_{{table_name}}_date_time
{%- endmacro %}

{% macro link_rec_source(table_name, source_id) -%}
    coalesce(NULL, {{source_id}}) AS link_{{table_name}}_rec_source,
{%- endmacro %}