{{ config(
    materialized='table',
    indexes=[
        {'columns': [var('f5500_source_table_year')]},
        {'columns': [var('f5500_naics_code')]}
    ]
) }}

select {{ dbt_utils.star(from=ref('stg_fct_f5500'), except=['remove_me'])}}
from {{ ref('stg_fct_f5500') }}
