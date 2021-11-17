{% test data_loss_against_pattern_union__long(model, source_tables_prefixes, acceptable_loss, run_test = True, test_mode = False) -%}
    {{ config(enabled = run_test) }}

    with raw_data_union as (
        {%- set unified_raw_tables = [[]] -%}
        {% for prefix in source_tables_prefixes %}
            {# https://stackoverflow.com/a/32700975/3517025 #}
            {# basically a hack for += in jinja #}
            {% if unified_raw_tables.append(unified_raw_tables.pop() + dbt_utils.get_relations_by_pattern(var('raw_schema') + '%', prefix + '%')) %}{% endif %} 
        {% endfor %}
        {{ dbt_utils.union_relations(relations=unified_raw_tables.pop()) }}
    ), 

    model_count as (
        select count(*) as _model_count
        from {{ model }}
    ),

    raw_data_count as (
        select count(*) as _raw_data_count
        from raw_data_union
    )

    select *
    from model_count cross join raw_data_count 
    {% if not test_mode %}
        where _model_count < _raw_data_count * (1 - {{ acceptable_loss }})
    {% endif %}

{%- endtest %}
