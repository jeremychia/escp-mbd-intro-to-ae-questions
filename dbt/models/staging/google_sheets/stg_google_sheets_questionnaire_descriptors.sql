with
    source as (
        select * from {{ source("escpmbd_google_sheets", "questionnaire_descriptors") }}
    ),
    renamed as (
        select
            parse_datetime(
                '%d/%m/%Y %H:%M:%S', {{ adapter.quote("timestamp") }}
            ) as submitted_at,
            {{ adapter.quote("email_address") }} as respondent_email,

            {{ adapter.quote("student_id") }} as response_description__student_id,
            {{ adapter.quote("student_name") }} as response_description__student_name,
            {{ adapter.quote("attendance") }} as response_description__attendance,
            {{ adapter.quote("avg_result") }} as response_description__avg_result,
            {{ adapter.quote("applied_on") }} as response_description__applied_on,
            {{ adapter.quote("admitted_on") }} as response_description__admitted_on,

        from source
    )
select *
from renamed
