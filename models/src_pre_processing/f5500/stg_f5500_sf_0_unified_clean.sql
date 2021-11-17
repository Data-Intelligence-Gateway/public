with stg_f5500_sf_unified as (
  {%- set f5500_sf = dbt_utils.get_relations_by_pattern(var('raw_schema') + '%', 'f5500_sf%') -%}

  -- test business code for naics values
  -- taking sf_tot_act_partcp_boy_cnt where possible for more accurate number, sf_tot_partcp_boy_cnt includes inactive participants
  -- taking sf_tot_act_partcp_eoy_cnt for end of year where possible, otherwise sf_partcp_account_bal_cnt is "Number of participants with account balances as of the end of the plan year(defined benefit plans do not complete this item)"

  -- address: 
  --              mail_us:        'sf_spons_us_address1', 'sf_spons_us_address2', 'sf_spons_us_city', 'sf_spons_us_state', 'sf_spons_us_zip'
  --              loc_us:         'sf_spons_loc_us_address1', 'sf_spons_loc_us_address2', 'sf_spons_loc_us_city', 'sf_spons_loc_us_state', 'sf_spons_loc_us_zip'
  --              mail_foreign:   'sf_spons_foreign_address1', 'sf_spons_foreign_address2', 'sf_spons_foreign_city', 'sf_spons_foreign_prov_state', 'sf_spons_foreign_cntry', 'sf_spons_foreign_postal_cd'
  --              loc_foreign:    'sf_spons_loc_foreign_address1', 'sf_spons_loc_foreign_address2', 'sf_spons_loc_foreign_city', 'sf_spons_loc_foreign_prov_stat', 'sf_spons_loc_foreign_cntry', 'sf_spons_loc_foreign_postal_cd'

  -- sf_spons_signed_name is a person's name

  {%- set cols = ['ack_id', 'sf_spons_ein', 'sf_plan_year_begin_date', 'sf_plan_eff_date', 'sf_plan_name', 'sf_business_code', 'date_received',
                  'sf_sponsor_name', 'sf_sponsor_dfe_dba_name', 'sf_tot_act_partcp_boy_cnt', 'sf_tot_partcp_boy_cnt', 'sf_tot_act_partcp_eoy_cnt', 'sf_partcp_account_bal_cnt',
                  'sf_spons_us_address1', 'sf_spons_us_address2', 'sf_spons_us_city', 'sf_spons_us_state', 'sf_spons_us_zip',
                  'sf_spons_loc_us_address1', 'sf_spons_loc_us_address2', 'sf_spons_loc_us_city', 'sf_spons_loc_us_state', 'sf_spons_loc_us_zip',
                  'sf_spons_foreign_address1', 'sf_spons_foreign_address2', 'sf_spons_foreign_city', 'sf_spons_foreign_prov_state', 'sf_spons_foreign_cntry', 'sf_spons_foreign_postal_cd',
                  'sf_spons_loc_foreign_address1', 'sf_spons_loc_foreign_address2', 'sf_spons_loc_foreign_city', 'sf_spons_loc_foreign_prov_stat', 'sf_spons_loc_foreign_cntry', 'sf_spons_loc_foreign_postal_cd',
                  'sf_spons_phone_num', 'sf_spons_phone_num_foreign', 'sf_spons_signed_name', 'sf_admin_signed_name', 'sf_admin_phone_num', 'sf_admin_phone_num_foreign' ] -%}


  {{ dbt_utils.union_relations(relations = f5500_sf, include=cols ) }}
), 

stg_renamed_cols_f5500_sf as (
    select 
      {{ var('source_table') }},
      {{ extract_year_from_source_table_column() }} as {{ var('f5500_source_table_year') }},
      ack_id as {{ var('f5500_id') }},
      cast({{ extract_digits_from_column('sf_spons_ein')}} as numeric) as {{ var('f5500_ein') }},
      {{ target.schema }}.f_cast_text_to_date_or_null(sf_plan_year_begin_date) as {{ var('f5500_plan_year_begin_date') }},
      {{ add_corrupted_date_col_original_text('sf_plan_year_begin_date') }} as {{ var('f5500_corrupted_plan_year_begin_date') }},
      {{ target.schema }}.f_cast_text_to_date_or_null(sf_plan_eff_date) as {{ var('f5500_plan_effective_date') }},
      {{ add_corrupted_date_col_original_text('sf_plan_eff_date') }} as {{ var('f5500_corrupted_plan_eff_date') }},
      sf_plan_name as {{ var('f5500_plan_name') }},
      {{ target.schema }}.f_cast_text_to_date_or_null(date_received) as {{ var('f5500_date_received') }},
      {{ add_corrupted_date_col_original_text('date_received') }} as {{ var('f5500_corrupted_date_received_date') }},
      {{ target.schema }}.f_cast_text_to_numeric_or_null(sf_business_code) as {{ var('f5500_naics_code') }},
      sf_sponsor_name as {{ var('f5500_sponsor_corporate_name') }},
      sf_sponsor_dfe_dba_name as {{ var('f5500_doing_busines_as_name') }},
      coalesce(sf_tot_act_partcp_boy_cnt, sf_tot_partcp_boy_cnt) as {{ var('f5500_boy_partcp_count') }},
      sf_tot_act_partcp_boy_cnt is not NULL as {{ var('f5500_is_boy_partcp_count_active_only') }},
      coalesce(sf_tot_act_partcp_eoy_cnt, sf_partcp_account_bal_cnt) as {{ var('f5500_eoy_active_partcp_count') }},
      sf_tot_act_partcp_eoy_cnt is not NULL as {{ var('f5500_is_eoy_partcp_count_active_only') }},
      sf_spons_us_address1 as {{ var('f5500_us_mail_address1') }},
      sf_spons_us_address2 as {{ var('f5500_us_mail_address2') }},
      sf_spons_us_city as {{ var('f5500_us_mail_city') }},
      sf_spons_us_state as {{ var('f5500_us_mail_state') }},
      sf_spons_us_zip as {{ var('f5500_us_mail_zip_code') }},
      sf_spons_loc_us_address1 as {{ var('f5500_us_loc_address1') }},
      sf_spons_loc_us_address2 as {{ var('f5500_us_loc_address2') }},
      sf_spons_loc_us_city as {{ var('f5500_us_loc_city') }},
      sf_spons_loc_us_state as {{ var('f5500_us_loc_state') }},
      sf_spons_loc_us_zip as {{ var('f5500_us_loc_zip_code') }},
      sf_spons_foreign_address1 as {{ var('f5500_foreign_address1') }}, 
      sf_spons_foreign_address2 as {{ var('f5500_foreign_address2') }},
      sf_spons_foreign_city as {{ var('f5500_foreign_mail_city') }},
      sf_spons_foreign_prov_state as {{ var('f5500_foreign_mail_province_or_state') }},
      sf_spons_foreign_cntry as {{ var('f5500_foreign_mail_country') }},
      sf_spons_foreign_postal_cd as {{ var('f5500_foreign_mail_postal_code') }},
      sf_spons_loc_foreign_address1 as {{ var('f5500_foreign_loc_address1') }}, 
      sf_spons_loc_foreign_address2 as {{ var('f5500_foreign_loc_address2') }}, 
      sf_spons_loc_foreign_city as {{ var('f5500_foreign_loc_city') }}, 
      sf_spons_loc_foreign_prov_stat as {{ var('f5500_foreign_loc_province_or_state') }}, 
      sf_spons_loc_foreign_cntry as {{ var('f5500_foreign_loc_country') }}, 
      sf_spons_loc_foreign_postal_cd as {{ var('f5500_foreign_loc_postal_code') }},
      sf_spons_phone_num as {{ var('f5500_contact_phone_num') }},
      sf_spons_phone_num_foreign as {{ var('f5500_foreign_phone_number') }},
      sf_spons_signed_name as {{ var('f5500_contact_name') }},
      sf_admin_signed_name as {{ var('f5500_admin_signed_name') }},
      sf_admin_phone_num as {{ var('f5500_admin_phone_num') }},
      sf_admin_phone_num_foreign as {{ var('f5500_admin_foreign_phone_num') }}
    from stg_f5500_sf_unified
)

select * from stg_renamed_cols_f5500_sf
