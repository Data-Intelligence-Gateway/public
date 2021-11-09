{{ config(materialized='ephemeral')}}

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
--              mail_foreign:   'spons_dfe_mail_foreign_city', 'spons_dfe_mail_forgn_prov_st', 'spons_dfe_mail_foreign_cntry', 'spons_dfe_mail_forgn_postal_cd'
--              loc_foreign:    'spons_dfe_loc_foreign_address1', 'spons_dfe_loc_foreign_address2', 'spons_dfe_loc_foreign_city', 'spons_dfe_loc_forgn_prov_st', 'spons_dfe_loc_foreign_cntry', 'spons_dfe_loc_forgn_postal_cd'

-- spons_signed_name is a person's name
-- do we need admin name and phone? 

{%- set cols = ['ack_id', 'filing_id', 'spons_dfe_ein', 'plan_eff_date', 'plan_name', 'business_code', 'date_received',
                'sponsor_dfe_name', 'spons_dfe_dba_name', 'tot_act_partcp_boy_cnt', 'tot_partcp_boy_cnt', 'tot_active_partcp_cnt',
                'spons_dfe_mail_str_address', 'spons_dfe_city', 'spons_dfe_state', 'spons_dfe_zip_code', 'spons_dfe_loc_addr',
                'spons_dfe_mail_us_address1', 'spons_dfe_mail_us_address2', 'spons_dfe_mail_us_city', 'spons_dfe_mail_us_state', 'spons_dfe_mail_us_zip',
                'spons_dfe_loc_us_address1', 'spons_dfe_loc_us_address2', 'spons_dfe_loc_us_city', 'spons_dfe_loc_us_state', 'spons_dfe_loc_us_zip',
                'spons_dfe_mail_foreign_city', 'spons_dfe_mail_forgn_prov_st', 'spons_dfe_mail_foreign_cntry', 'spons_dfe_mail_forgn_postal_cd',
                'spons_dfe_loc_foreign_address1', 'spons_dfe_loc_foreign_address2', 'spons_dfe_loc_foreign_city', 'spons_dfe_loc_forgn_prov_st', 'spons_dfe_loc_foreign_cntry', 'spons_dfe_loc_forgn_postal_cd',
                'spons_dfe_phone_num', 'spons_signed_name' ] -%}


{{ dbt_utils.union_relations(relations = f5500_all, include=cols ) }}
