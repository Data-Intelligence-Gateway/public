{{ config(materialized='ephemeral')}}

-- TODO: if naics seed is later built on a manually configured schema, this might break
-- Technical Dept
{%- set naics_rels = dbt_utils.get_relations_by_pattern(target.schema, 'naics%') -%}
{%- set cols_overrid = {'code': 'text', 'title': 'text', 'description':'text'} -%}
{{ dbt_utils.union_relations(relations = naics_rels, column_override=cols_overrid) }}
