{% macro extract_year_from_source_table(source_table = var('source_table'), n=4) -%}
    {{extract_last_n_digits_from_column(source_table, n)}}
{%- endmacro %}
