with
    source as (select * from {{ source("escpmbd_google_sheets", "answers_roles") }}),
    renamed as (
        select
            {{ adapter.quote("questions") }} as response_role__question,
            {{ adapter.quote("answers") }} as response_role__correct_answer,

        from source
    )
select *
from renamed
