{% macro extract_digits_from_column(column_name) -%}
    regexp_replace({{ column_name }}, '\D','','g')
{%- endmacro %}
