{{ config(materialized='view', sort='customer_id') }}

{% set yaml_metadata %}

source_model: raw_customers
derived_columns:
    RECORD_SOURCE: "!SQL-SERVER"
    LOAD_DATE: DATE_ADD(order_date, INTERVAL 30 DAY)
    EFFECTIVE_FROM: order_date
hashed_columns:
    CUSTOMER_PK: customer_id
    CUSTOMER_HASHDIFF:
        is_hashdiff: true
        columns:
            - first_name
            - last_name
            - phone
            - email
            - street
            - city
            - state
            - zip_code
            - EFFECTIVE_FROM
{%endset%}
-- derived cols are made from existing columns
-- hashed columns convert existing keys into strings for link and satellite joins
-- hashdiff contains detail columns for satellite table (include natural key)

{% set metadata_dict = fromyaml(yaml_metadata) %}
--convert metadata listed above into a callable dictionary

{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns']%}
{% set hashed_columns = metadata_dict['hashed_columns']%}

{{ automate_dv.stage(
    include_source_columns = true,
    source_model = source_model,
    derived_columns = derived_columns,
    hashed_columns = hashed_columns
    )
}}