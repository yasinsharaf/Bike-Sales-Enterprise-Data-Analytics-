{{ config(materialized='view') }}

{% set yaml_metadata %}

source_model: raw_products
derived_columns:
    RECORD_SOURCE: "!SQL-SERVER"
    LOAD_DATE: earliest_order_date
    EFFECTIVE_FROM: earliest_order_date
hashed_columns:
    PRODUCT_PK: product_id
    CATEGORY_PK: category_id
    BRAND_PK: brand_id
    PRODUCT_CATEGORY_PK:
        - category_id
        - product_id
    PRODUCT_BRAND_PK:
        - brand_id
        - product_id
    PRODUCT_HASHDIFF:
        is_hashdiff: true
        columns:
            - product_id
            - product_name
            - brand_id
            - category_id
            - model_year
            - list_price
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