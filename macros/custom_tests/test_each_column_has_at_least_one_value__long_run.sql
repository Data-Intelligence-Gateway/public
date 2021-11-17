{% test each_column_has_at_least_one_value__long(model, run_test) %}
  {{ config(enabled = run_test) }}
    
  select
    {%- set columns = adapter.get_columns_in_relation(model) -%}
    {% for column in columns %}
      count(distinct {{ column.name }}) as col_{{ loop.index }}      {%- if not loop.last -%},{% endif -%}
    {% endfor %}
  from {{ model }}
  having
    {% for column in columns %}
      count(distinct {{ column.name }})=0      {%- if not loop.last %} or {%- endif -%}
    {% endfor %}

{% endtest %}
