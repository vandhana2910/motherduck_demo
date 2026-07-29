SELECT
    * EXCLUDE(Date),
    CAST(Date AS DATE) AS Date
FROM {{ ref('base_ms_industry_2024') }}