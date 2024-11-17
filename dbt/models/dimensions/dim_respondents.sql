with
    source as (
        select
            respondent_email,
            respondent_class,

            respondent_work_experience,
            respondent_bachelors,
            respondent_awareness_analytics_engineering,
            respondent_awareness_tools,
            respondent_sql_level,

            submitted_at
        from {{ ref("stg_google_sheets_questionnaire_roles") }}
    ),

    renamed as (
        select
            respondent_email,
            respondent_class,

            respondent_work_experience as work_experience,
            respondent_bachelors as bachelors,
            respondent_awareness_analytics_engineering
            as awareness_analytics_engineering,
            respondent_awareness_tools as awareness_tools,
            respondent_sql_level as sql_level,

            submitted_at,
            min(submitted_at) over (
                partition by respondent_email
            ) as first_submission_at,
            max(submitted_at) over (partition by respondent_email) as last_updated_at

        from source
    ),

    deduplicated as (
        select * except (submitted_at)
        from renamed
        -- keep only latest response
        qualify
            row_number() over (partition by respondent_email order by submitted_at desc)
            = 1

    )

select *
from deduplicated
