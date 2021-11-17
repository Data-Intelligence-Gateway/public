{% macro extract_digits_from_column(column_name) -%}
CASE 
  WHEN regexp_replace({{ column_name }}, '\D','','g') <> '' THEN regexp_replace({{ column_name }}, '\D','','g')
  ELSE NULL
END
{%- endmacro %}
