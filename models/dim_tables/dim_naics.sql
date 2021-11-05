{{ config(materialized='table')}}


with stg_unified_naics as (
    select *
    from {{ ref('stg_unified_naics') }} 
),

stg_source_year_and_numeric_codes_naics as (
    select 
      -- https://stackoverflow.com/a/40564710/3517025
      regexp_replace({{ var('source_table') }}, '\D','','g'):: numeric as source_year, 
      cast(code as numeric), title, description
    from stg_unified_naics
    -- https://stackoverflow.com/a/2894527/3517025
    where code ~ E'^\\d+$'
),

stg_numbered_duplicate_naics as (
    select *,
      --https://stackoverflow.com/a/966215/3517025
      ROW_NUMBER() OVER (PARTITION BY code ORDER BY source_year desc) AS rownumber
    from stg_source_year_and_numeric_codes_naics
),

stg_distinct_codes_with_legacy_naics as (
    select source_year, code, title, description
    from stg_numbered_duplicate_naics
    where rownumber=1
)

select * from stg_distinct_codes_with_legacy_naics