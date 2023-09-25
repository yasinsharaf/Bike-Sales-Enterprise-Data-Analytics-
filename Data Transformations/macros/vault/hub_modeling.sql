{% macro hub_id(table_name, pk) -%}
    row_number() over (order by {{pk}}) as hub_{{table_name}}_id
{%- endmacro %}

{% macro hub_datetime(table_name) -%}
    timestamp(datetime(current_timestamp(), 'America/Los_Angeles')) as hub_{{table_name}}_date_time
{%- endmacro %}

{% macro hub_rec_source(table_name, source_id) -%}
    coalesce(NULL, {{source_id}}) AS hub_{{table_name}}_rec_source,
{%- endmacro %}