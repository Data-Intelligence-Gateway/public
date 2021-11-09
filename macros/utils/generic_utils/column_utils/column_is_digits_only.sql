{% macro column_is_digits_only(column) -%}
{#- https://stackoverflow.com/a/2894527/3517025 -#}
    {{ column }} ~ E'^\\d+$'
{%- endmacro %}
