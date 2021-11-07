{% macro extract_year_from_source_table_column(source_table = var('source_table')) -%}
{#- https://stackoverflow.com/a/40564710/3517025 -#}
    regexp_replace({{ source_table }}, '\D','','g')
{%- endmacro %}
