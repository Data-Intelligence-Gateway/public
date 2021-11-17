{% test columns_are_mutually_exclusive(model, col1, col2) %}

with validation as (

    select
        {{ col1 }} as col1,
        {{ col2 }} as col2

    from {{ model }}

),

validation_errors as (

    select
        col1
    from validation
    where col1 is not null and col2 is not null
)

select *
from validation_errors

{% endtest %}