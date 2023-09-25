{% macro hashkey(col_name) %}

CAST(UPPER(TO_HEX(MD5(NULLIF(UPPER(TRIM(CAST({{col_name}} AS STRING))), '')))) AS STRING)

{% endmacro %}