{% macro create_udfs() -%}
{# https://discourse.getdbt.com/t/using-dbt-to-manage-user-defined-functions/18 #}

create schema if not exists {{target.schema}};

-- TODO: loop over all UDFs 
{{ create_f_cast_text_to_numeric_or_null() }}
-- don't forget to add ';' 

{%- endmacro %}
