with fct_f5500_filtered_by_naics_yr as (
    select ein,plan_name,sponsor_corporate_name,

          plan_year_begin_date,plan_effective_date,

          us_mail_city,us_mail_state,us_mail_zip_code,us_mail_address1,us_mail_address2

          naics_code,eoy_active_partcp_count

    from  {{ ref('fct_f5500') }}

    where LOWER(sponsor_corporate_name) like '%power service%' or LOWER(sponsor_corporate_name) like '%electrical testing%'
        or LOWER(sponsor_corporate_name) like '%field testing%' or LOWER(sponsor_corporate_name) like '%electrical service%'
),

 

epr_cte as (

    select ein, min(plan_year_begin_date) as epr

    from fct_f5500_filtered_by_naics_yr

    group by ein

),

 

latest_yr_cte as (

    select ein, max(plan_year_begin_date) as lry

    from fct_f5500_filtered_by_naics_yr

    group by ein

    having max(plan_year_begin_date) >= '2018-01-01'

),

 

fct_f5500_with_lry_epr as (

    select fct_f5500_filtered_by_naics_yr.*,

          extract(year from lry)  lry_yr,

          (case when epr < plan_effective_date then extract(year from epr) else extract(year from plan_effective_date) end ) epr_yr

    from latest_yr_cte

    left join fct_f5500_filtered_by_naics_yr 

               on latest_yr_cte.ein = fct_f5500_filtered_by_naics_yr.ein

               and lry = fct_f5500_filtered_by_naics_yr.plan_year_begin_date

    left join epr_cte

              on epr_cte.ein = fct_f5500_filtered_by_naics_yr.ein 

),

 

fct_f5500_with_lry_epr_rnk as (

    select *, RANK () OVER (PARTITION BY ein ORDER BY case when eoy_active_partcp_count is null then 0 else eoy_active_partcp_count end DESC) AS rnk

    from fct_f5500_with_lry_epr

),

 

fct_f5500_final as (

    select *  

    from fct_f5500_with_lry_epr_rnk

    where rnk = 1

)

 

select *

from fct_f5500_final

limit 1000000000
