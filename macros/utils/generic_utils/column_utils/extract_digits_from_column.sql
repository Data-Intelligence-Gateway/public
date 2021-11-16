{% macro extract_digits_from_column(column_name, n) -%}
    regexp_replace({{ column_name }}, '\D','','g')
{%- endmacro %}
