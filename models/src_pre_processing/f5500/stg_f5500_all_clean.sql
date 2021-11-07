with stg_unified_f5500_all as (
    select *
    from {{ref('stg_unified_f5500_all')}}
),

stg_renamed_cols_f5500_all as (
    select 
      {{ var('source_table') }},
      coalesce(ack_id, cast(filing_id as text)) as {{ var('f5500_id') }},
      spons_dfe_ein as {{ var('f5500_ein') }},
      plan_eff_date as {{ var('f5500_plan_effective_date') }},
      {{ var('f5500_plan_name') }}, {{ var('f5500_date_received') }},
      {{target.schema}}.f_cast_text_to_numeric_or_null(business_code) as {{ var('f5500_naics_code') }},
      sponsor_dfe_name as {{ var('f5500_sponsor_corporate_name') }},
      sponsor_dfe_name as {{ var('f5500_doing_busines_as_name') }},
      coalesce(tot_act_partcp_boy_cnt, tot_partcp_boy_cnt) as {{ var('f5500_boy_partcp_count') }},
      tot_act_partcp_boy_cnt is not NULL as {{ var('f5500_is_boy_partcp_count_active_only') }},
      tot_active_partcp_cnt as {{ var('f5500_eoy_active_partcp_count') }},
      spons_dfe_mail_str_address as {{ var('f5500_pre_2009_mailing_address') }},
      spons_dfe_city as {{ var('f5500_pre_2009_mailing_city') }},
      spons_dfe_state as {{ var('f5500_pre_2009_state') }},
      spons_dfe_zip_code as {{ var('f5500_pre_2009_zip_code') }},
      spons_dfe_loc_addr as {{ var('f5500_pre_2009_loc_address') }},
      spons_dfe_mail_us_address1 as {{ var('f5500_us_mail_address1') }},
      spons_dfe_mail_us_address2 as {{ var('f5500_us_mail_address2') }},
      spons_dfe_mail_us_city as {{ var('f5500_us_mail_city') }},
      spons_dfe_mail_us_state as {{ var('f5500_us_mail_state') }},
      spons_dfe_mail_us_zip as {{ var('f5500_us_mail_zip_code') }},
      spons_dfe_loc_us_address1 as {{ var('f5500_us_loc_address1') }},
      spons_dfe_loc_us_address2 as {{ var('f5500_us_loc_address2') }},
      spons_dfe_loc_us_city as {{ var('f5500_us_loc_city') }},
      spons_dfe_loc_us_state as {{ var('f5500_us_loc_state') }},
      spons_dfe_loc_us_zip as {{ var('f5500_us_loc_zip_code') }},
      spons_dfe_mail_foreign_city as {{ var('f5500_foreign_mail_city') }},
      spons_dfe_mail_forgn_prov_st as {{ var('f5500_foreign_mail_province_or_state') }},
      spons_dfe_mail_foreign_cntry as {{ var('f5500_foreign_mail_country') }},
      spons_dfe_mail_forgn_postal_cd as {{ var('f5500_foreign_mail_postal_code') }},
      spons_dfe_phone_num as {{ var('f5500_contact_phone_num') }},
      spons_signed_name as {{ var('f5500_contact_name') }}
    from stg_unified_f5500_all
)

select * from stg_renamed_cols_f5500_all
