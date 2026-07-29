SELECT *
FROM {{ source('dbt_demo', 'ms_industry') }}