with stg_f5500_all_unified as (
  {%- set f5500_all = dbt_utils.get_relations_by_pattern('bronze%', 'f5500_all%') -%}

  -- test business code for naics values
  -- taking tot_act_partcp_boy_cnt where possible for more accurate number, tot_partcp_boy_cnt includes inactive participants
  -- tot_active_partcp_cnt for end of year

  -- address up to 2008 (inclusive): 
  --                              'spons_dfe_mail_str_address', 'spons_dfe_city', 'spons_dfe_state', 'spons_dfe_zip_code'
  --                              'spons_dfe_loc_addr' 

  -- address from 2009: 
  --              mail_us:        'spons_dfe_mail_us_address1', 'spons_dfe_mail_us_address2', 'spons_dfe_mail_us_city', 'spons_dfe_mail_us_state', 'spons_dfe_mail_us_zip'
  --              loc_us:         'spons_dfe_loc_us_address1', 'spons_dfe_loc_us_address2', 'spons_dfe_loc_us_city', 'spons_dfe_loc_us_state', 'spons_dfe_loc_us_zip'
  --              mail_foreign:   'spons_dfe_mail_foreign_addr1', 'spons_dfe_mail_foreign_addr2', 'spons_dfe_mail_foreign_city', 'spons_dfe_mail_forgn_prov_st', 'spons_dfe_mail_foreign_cntry', 'spons_dfe_mail_forgn_postal_cd'
  --              loc_foreign:    'spons_dfe_loc_foreign_address1', 'spons_dfe_loc_foreign_address2', 'spons_dfe_loc_foreign_city', 'spons_dfe_loc_forgn_prov_st', 'spons_dfe_loc_foreign_cntry', 'spons_dfe_loc_forgn_postal_cd'

  -- spons_signed_name is a person's name
  -- do we need admin name and phone? 

  {%- set cols = ['ack_id', 'filing_id', 'spons_dfe_ein', 'plan_eff_date', 'plan_name', 'business_code', 'date_received',
                  'sponsor_dfe_name', 'spons_dfe_dba_name', 'tot_act_partcp_boy_cnt', 'tot_partcp_boy_cnt', 'tot_active_partcp_cnt',
                  'spons_dfe_mail_str_address', 'spons_dfe_city', 'spons_dfe_state', 'spons_dfe_zip_code', 'spons_dfe_loc_addr',
                  'spons_dfe_mail_us_address1', 'spons_dfe_mail_us_address2', 'spons_dfe_mail_us_city', 'spons_dfe_mail_us_state', 'spons_dfe_mail_us_zip',
                  'spons_dfe_loc_us_address1', 'spons_dfe_loc_us_address2', 'spons_dfe_loc_us_city', 'spons_dfe_loc_us_state', 'spons_dfe_loc_us_zip',
                  'spons_dfe_mail_foreign_addr1', 'spons_dfe_mail_foreign_addr2', 'spons_dfe_mail_foreign_city', 'spons_dfe_mail_forgn_prov_st', 'spons_dfe_mail_foreign_cntry', 'spons_dfe_mail_forgn_postal_cd',
                  'spons_dfe_loc_foreign_address1', 'spons_dfe_loc_foreign_address2', 'spons_dfe_loc_foreign_city', 'spons_dfe_loc_forgn_prov_st', 'spons_dfe_loc_foreign_cntry', 'spons_dfe_loc_forgn_postal_cd',
                  'spons_dfe_phone_num', 'spons_dfe_phone_num_foreign', 'spons_signed_name', 'admin_signed_name', 'admin_phone_num', 'admin_phone_num_foreign' ] -%}


  {{ dbt_utils.union_relations(relations = f5500_all, include=cols ) }}
), 

stg_renamed_cols_f5500_all as (
    select 
      {{ var('source_table') }},
      coalesce(ack_id, cast(filing_id as text)) as {{ var('f5500_id') }},
      spons_dfe_ein as {{ var('f5500_ein') }},
      plan_eff_date as {{ var('f5500_plan_effective_date') }},
      plan_name as {{ var('f5500_plan_name') }},
      date_received as {{ var('f5500_date_received') }},
      {{target.schema}}.f_cast_text_to_numeric_or_null(business_code) as {{ var('f5500_naics_code') }},
      sponsor_dfe_name as {{ var('f5500_sponsor_corporate_name') }},
      spons_dfe_dba_name as {{ var('f5500_doing_busines_as_name') }},
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
      spons_dfe_mail_foreign_addr1 as {{ var('f5500_foreign_address1') }}, 
      spons_dfe_mail_foreign_addr2 as {{ var('f5500_foreign_address2') }},
      spons_dfe_mail_foreign_city as {{ var('f5500_foreign_mail_city') }},
      spons_dfe_mail_forgn_prov_st as {{ var('f5500_foreign_mail_province_or_state') }},
      spons_dfe_mail_foreign_cntry as {{ var('f5500_foreign_mail_country') }},
      spons_dfe_mail_forgn_postal_cd as {{ var('f5500_foreign_mail_postal_code') }},
      spons_dfe_loc_foreign_address1 as {{ var('f5500_foreign_loc_address1') }}, 
      spons_dfe_loc_foreign_address2 as {{ var('f5500_foreign_loc_address2') }}, 
      spons_dfe_loc_foreign_city as {{ var('f5500_foreign_loc_city') }}, 
      spons_dfe_loc_forgn_prov_st as {{ var('f5500_foreign_loc_province_or_state') }}, 
      spons_dfe_loc_foreign_cntry as {{ var('f5500_foreign_loc_country') }}, 
      spons_dfe_loc_forgn_postal_cd as {{ var('f5500_foreign_loc_postal_code') }},
      spons_dfe_phone_num as {{ var('f5500_contact_phone_num') }},
      spons_dfe_phone_num_foreign as {{ var('f5500_foreign_phone_number') }},
      spons_signed_name as {{ var('f5500_contact_name') }},
      admin_signed_name as {{ var('f5500_admin_signed_name') }},
      admin_phone_num as {{ var('f5500_admin_phone_num') }},
      admin_phone_num_foreign as {{ var('f5500_admin_foreign_phone_num') }}
    from stg_f5500_all_unified
)

select * from stg_renamed_cols_f5500_all
