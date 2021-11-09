{% macro extract_last_n_digits_from_column(column_name, n) -%}
    right(regexp_replace({{ column_name }}, '\D','','g'), {{n}})::numeric
{%- endmacro %}
