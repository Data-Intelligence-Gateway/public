{{ config(materialized='table')}}

{%- set naics_rels = dbt_utils.get_relations_by_pattern(target.schema, 'naics%') -%}
{%- set cols_overrid = {'code': 'numeric', 'title': 'text', 'description':'text'} -%}
{{ dbt_utils.union_relations(relations = naics_rels, column_override=cols_overrid) }}


