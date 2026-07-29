SELECT
    * EXCLUDE (Date_Range_Gross, Prev_Year_Range_Gross, Date),

    -- Clean currency columns: strip $ and commas, cast to double
    CAST(REPLACE(REPLACE(Date_Range_Gross, '$', ''), ',', '') AS DOUBLE) AS date_range_gross,
    CAST(REPLACE(REPLACE(Prev_Year_Range_Gross, '$', ''), ',', '') AS DOUBLE) AS prev_year_range_gross,

    -- Clean date column
    CAST(Date AS DATE) AS date_clean,
    CAST(Date AS DATE) AS Date

FROM {{ ref('base_ms_data') }}