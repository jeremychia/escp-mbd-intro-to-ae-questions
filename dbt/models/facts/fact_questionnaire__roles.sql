with
    submitted_answers_source as (
        select
            respondent_email,
            submitted_at,

            response_role__build_custom_data_ingestion_integrations,  -- 1
            response_role__manage_overall_pipeline_orchestration,  -- 2
            response_role__develop_and_deploy_machine_learning_endpoints,  -- 3
            response_role__build_and_maintain_the_data_platform,  -- 4
            response_role__data_warehouse_performance_optimisation,  -- 5
            response_role__provide_clean_transformed_data_ready_for_analysis,  -- 6
            response_role__apply_software_engineering_practices_to_analytics_code,  -- 7
            response_role__maintain_data_documentation_and_definitions,  -- 8
            response_role__deep_insights_work,  -- 9
            response_role__work_with_business_users_to_understand_data_requirements,  -- 10
            response_role__build_critical_dashboards,  -- 11
            response_role__forecasting,  -- 12

        from {{ ref("stg_google_sheets_questionnaire_roles") }}
    ),

    submitted_answers_long as (
        select
            respondent_email,
            submitted_at,
            replace(question, 'response_role__', '') as response_role__question,
            submitted_answer as response_role__submitted_answer
        from
            submitted_answers_source unpivot (
                submitted_answer for question in (
                    response_role__build_custom_data_ingestion_integrations,
                    response_role__manage_overall_pipeline_orchestration,
                    response_role__develop_and_deploy_machine_learning_endpoints,
                    response_role__build_and_maintain_the_data_platform,
                    response_role__data_warehouse_performance_optimisation,
                    response_role__provide_clean_transformed_data_ready_for_analysis,
                    response_role__apply_software_engineering_practices_to_analytics_code,
                    response_role__maintain_data_documentation_and_definitions,
                    response_role__deep_insights_work,
                    response_role__work_with_business_users_to_understand_data_requirements,
                    response_role__build_critical_dashboards,
                    response_role__forecasting
                )
            )
    ),

    correct_answers as (
        select response_role__question, response_role__correct_answer
        from {{ ref("stg_google_sheets_answers_roles") }}
    ),

    check_answers as (
        select
            submitted_answers.respondent_email,
            submitted_answers.submitted_at,
            submitted_answers.response_role__question,
            submitted_answers.response_role__submitted_answer,
            correct_answers.response_role__correct_answer,
            if(
                submitted_answers.response_role__submitted_answer
                = correct_answers.response_role__correct_answer,
                true,
                false
            ) as is_correct,
        from submitted_answers_long as submitted_answers
        left join
            correct_answers
            on submitted_answers.response_role__question
            = correct_answers.response_role__question
    )

select *
from check_answers
