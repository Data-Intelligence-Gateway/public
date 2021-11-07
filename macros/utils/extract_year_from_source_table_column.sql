{% macro extract_year_from_source_table_column() -%}
{#- https://stackoverflow.com/a/40564710/3517025 -#}
    regexp_replace({{ var('source_table') }}, '\D','','g')
{%- endmacro %}
