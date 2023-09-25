{{ config(materialized='table') }}

{% set source_model = "v_stg_stocks" %}
{% set src_pk = "STORE_PRODUCT_PK" %}
{% set src_fk = ["STORE_PK", "PRODUCT_PK"] %}
{% set src_ldts = "LOAD_DATE" %}
{% set src_source = "RECORD_SOURCE" %}

{{ automate_dv.link(
    src_pk = src_pk,
    src_fk = src_fk,
    src_ldts = src_ldts,
    src_source = src_source,
    source_model = source_model
    )
}}