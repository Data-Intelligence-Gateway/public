{% test data_loss_against_model__long(model, other_model, acceptable_loss, run_test = True, test_mode = False) -%}
    {{ config(enabled = run_test) }}

    with model_count as (
        select count(*) as _model_count
        from {{ model }}
    ),

    other_model_count as (
        select count(*) as _other_model_count
        from {{ ref(other_model) }}
    )

    select *
    from model_count cross join other_model_count 
    {% if not test_mode %}
        where _model_count < _other_model_count * (1 - {{ acceptable_loss }})
    {% endif %}

{%- endtest %}
