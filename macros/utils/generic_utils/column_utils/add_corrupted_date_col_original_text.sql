{% macro add_corrupted_date_col_original_text(source_date_col) -%}    
CASE 
  WHEN (({{ source_date_col }} <> '') AND ({{ target.schema }}.f_cast_text_to_date_or_null({{ source_date_col }}) IS NULL)) THEN {{ source_date_col }}
  ELSE NULL
END
{%- endmacro %}  
