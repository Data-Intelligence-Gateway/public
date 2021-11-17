{% macro extract_rightmost_n_digits_from_column(column_name, n) -%}
    right({{ extract_digits_from_column(column_name) }}, {{n}})::numeric
{%- endmacro %}
