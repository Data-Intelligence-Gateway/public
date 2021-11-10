{{ config(materialized='table') }}

select {{ dbt_utils.star(from=ref('stg_fct_f5500'), except=['remove_me'])}}
from {{ ref('stg_fct_f5500') }}
