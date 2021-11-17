{{ config(materialized='table')}}

select *
from {{ ref('stg_distinct_codes_all_years_naics') }}
