{{ dbt_utils.union_relations(relations=[ref('stg_f5500_all_1_deduped_ids'), ref('stg_f5500_sf_0_unified_clean')], source_column_name='remove_me') }}
