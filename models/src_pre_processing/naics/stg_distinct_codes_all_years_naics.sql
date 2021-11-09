with stg_unified_naics as (
    select *
    from {{ ref('stg_unified_naics') }} 
),

stg_source_year_and_numeric_codes_naics as (
    select 
      {{ extract_year_from_source_table_column() }} as source_year, 
      cast(code as numeric), title, description
    from stg_unified_naics
    where {{ column_is_digits_only('code')}}
),

stg_numbered_duplicate_naics as (
    select *,
      ROW_NUMBER() OVER (PARTITION BY code ORDER BY source_year desc) AS rownumber
    from stg_source_year_and_numeric_codes_naics
),

stg_distinct_codes_with_legacy_naics as (
    select source_year, code, title, description
    from stg_numbered_duplicate_naics
    where rownumber=1
)

select * from stg_distinct_codes_with_legacy_naics
