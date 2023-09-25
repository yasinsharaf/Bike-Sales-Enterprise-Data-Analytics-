{{ config(materialized='view') }}

{% set yaml_metadata %}

source_model: raw_staffs
derived_columns:
    RECORD_SOURCE: "!SQL-SERVER"
    LOAD_DATE: earliest_order_date
    EFFECTIVE_FROM: earliest_order_date
hashed_columns:
    STAFF_PK: staff_id
    STORE_PK: store_id
    STORE_STAFF_PK:
        - staff_id
        - store_id
    STAFF_HASHDIFF:
        is_hashdiff: true
        columns:
            - staff_id
            - first_name
            - last_name
            - email
            - phone
            - active
            - store_id
            - manager_id
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