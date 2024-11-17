with
    source as (
        select * from {{ source("escpmbd_google_sheets", "questionnaire_roles") }}
    ),
    renamed as (
        select
            parse_datetime(
                '%d/%m/%Y %H:%M:%S', {{ adapter.quote("timestamp") }}
            ) as submitted_at,
            {{ adapter.quote("email_address") }} as respondent_email,

            {{ adapter.quote("score") }},

            {{ adapter.quote("select_your_class") }} as respondent_class,

            -- information about the respondent
            {{
                adapter.quote(
                    "how_many_years_of_work_experience_do_you_have_before_doing_the_masters"
                )
            }}
            as respondent_work_experience,
            {{ adapter.quote("what_is_your_bachelors_field_of_studies") }}
            as respondent_bachelors,
            {{ adapter.quote("have_you_heard_of_analytics_engineering") }}
            as respondent_awareness_analytics_engineering,
            {{ adapter.quote("do_you_know_how_to_programme_in_sql") }}
            as respondent_sql_level,
            {{ adapter.quote("have_you_heard_of_dbt_sqlmesh_or_sdf_or_other_tools") }}
            as respondent_awareness_tools,
            {{ adapter.quote("how_tired_are_you_when_coming_to_the_class_today") }}
            as respondent_energy_level,

            -- questionnaire responses
            {{ adapter.quote("build_custom_data_ingestion_integrations") }}
            as response_role__build_custom_data_ingestion_integrations,
            {{ adapter.quote("manage_overall_pipeline_orchestration") }}
            as response_role__manage_overall_pipeline_orchestration,
            {{ adapter.quote("develop_and_deploy_machine_learning_endpoints") }}
            as response_role__develop_and_deploy_machine_learning_endpoints,
            {{ adapter.quote("build_and_maintain_the_data_platform") }}
            as response_role__build_and_maintain_the_data_platform,
            {{ adapter.quote("data_warehouse_performance_optimisation") }}
            as response_role__data_warehouse_performance_optimisation,
            {{ adapter.quote("provide_clean_transformed_data_ready_for_analysis") }}
            as response_role__provide_clean_transformed_data_ready_for_analysis,
            {{
                adapter.quote(
                    "apply_software_engineering_practices_to_analytics_code"
                )
            }} as response_role__apply_software_engineering_practices_to_analytics_code,
            {{ adapter.quote("maintain_data_documentation_and_definitions") }}
            as response_role__maintain_data_documentation_and_definitions,
            {{ adapter.quote("deep_insights_work") }}
            as response_role__deep_insights_work,
            {{
                adapter.quote(
                    "work_with_business_users_to_understand_data_requirements"
                )
            }}
            as response_role__work_with_business_users_to_understand_data_requirements,
            {{ adapter.quote("build_critical_dashboards") }}
            as response_role__build_critical_dashboards,
            {{ adapter.quote("forecasting") }} as response_role__forecasting,

        from source
    )
select *
from renamed
