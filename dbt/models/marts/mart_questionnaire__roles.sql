with
    fact as (
        select *
        from {{ ref("fact_questionnaire__roles") }}
    ),

    respondents as (
        select *
        from {{ ref("dim_respondents") }}
    ),

    joined as (
        select 
            fact.*,
            respondents.* except(respondent_email)
        from fact
        left join respondents
            on fact.respondent_email = respondents.respondent_email
    )

select *
from joined