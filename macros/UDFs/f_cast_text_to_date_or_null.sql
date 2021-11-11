{% macro create_f_cast_text_to_date_or_null() -%}
{# https://blog.tplus1.com/blog/2016/05/30/postgresql-convert-a-string-to-a-date-or-null/ #}

CREATE OR REPLACE FUNCTION {{target.schema}}.f_cast_text_to_date_or_null(v_input text)
RETURNS DATE AS $$
DECLARE v_date_value DATE DEFAULT NULL;
BEGIN
    BEGIN
        v_date_value := v_input::DATE;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid date format or date value: "%".  Returning NULL.', v_input;
        RETURN NULL;
    END;
RETURN v_date_value;
END;
$$ LANGUAGE plpgsql;
{%- endmacro %}
