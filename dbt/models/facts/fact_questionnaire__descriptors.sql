with
    source as (
        select
            respondent_email,
            submitted_at,

            response_description__student_id,
            response_description__student_name,
            response_description__attendance,
            response_description__avg_result,
            response_description__applied_on,
            response_description__admitted_on,
        from {{ ref("stg_google_sheets_questionnaire_descriptors") }}
    ),

    description_responses_long as (
        select
            respondent_email,
            submitted_at,
            replace(field, 'response_description__', '') as field,
            submitted_answer,
        from
            source unpivot (
                submitted_answer for field in (
                    response_description__student_id,
                    response_description__student_name,
                    response_description__attendance,
                    response_description__avg_result,
                    response_description__applied_on,
                    response_description__admitted_on
                )
            )
    ),

    add_metrics as (
        select
            *,
            length(replace(submitted_answer, ' ', '')) as count_characters,
            array_length(split(submitted_answer, ' ')) as count_words
        from description_responses_long
    )

select *
from add_metrics
