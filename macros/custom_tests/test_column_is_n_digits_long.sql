{% test column_is_n_digits_long(model, column_name, n, acceptable_fail_rate = 0, run_test = True, test_mode = False) -%}
    {{ config(enabled = run_test) }}

    with conforming_count as (
        select count(*) as _good_digit_count
        from {{ model }}
        where {{ column_name }} is not null and {{ column_name }} <> 0 and FLOOR(LOG10(ABS({{ column_name }}))) + 1 = {{ n }}
    ),

    total_count as (
        select count(*) as _total_count
        from {{ model }}
    )

    select *
    from conforming_count cross join total_count 
    {% if not test_mode %}
        where _good_digit_count < _total_count * (1 - {{ acceptable_fail_rate }})
    {% endif %}

{%- endtest %}
