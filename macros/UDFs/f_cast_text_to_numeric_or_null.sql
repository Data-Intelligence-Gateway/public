{% macro create_f_cast_text_to_numeric_or_null() -%}
{# https://stackoverflow.com/a/2095676/3517025 #}
{# https://discourse.getdbt.com/t/using-dbt-to-manage-user-defined-functions/18 #}

CREATE OR REPLACE FUNCTION {{target.schema}}.f_cast_text_to_numeric_or_null(v_input text)
RETURNS NUMERIC AS $$
DECLARE v_int_value NUMERIC DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::NUMERIC;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid numeric value: "%".  Returning NULL.', v_input;
        RETURN NULL;
    END;
RETURN v_int_value;
END;
$$ LANGUAGE plpgsql;
{%- endmacro %}
