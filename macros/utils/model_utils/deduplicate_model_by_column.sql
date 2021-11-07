{% macro deduplicate_model_by_column(model, corrupted_column) -%}

with original_model as (
  select *
  from {{ model }}
),

 _corrupted_column_values as (
  select {{ corrupted_column }} as corrupted
  from original_model
  group by {{ corrupted_column }}
  having count(*) > 1
),

_corrupted_rows_with_dup_counter as (
  select *,
    ROW_NUMBER() OVER (PARTITION BY a.{{ corrupted_column }}) AS dup_counter
  from original_model as a
  inner join _corrupted_column_values as b on a.{{ corrupted_column }} = b.corrupted
),

_selected_rows_to_return as (
  select
    {{ dbt_utils.star(model) }}
  from _corrupted_rows_with_dup_counter
  where dup_counter = 1
),

_original_model_sans_all_corrupted_rows as (
  select
    {{ dbt_utils.star(model) }}
  from original_model as a
  left join _corrupted_column_values as b on a.{{ corrupted_column }} = b.corrupted
  where b.corrupted is NULL
),

_union_clean_model_with_selected_rows as (
  select * from _original_model_sans_all_corrupted_rows
  union all
  select * from _selected_rows_to_return
)

select * from _union_clean_model_with_selected_rows
{%- endmacro %}
