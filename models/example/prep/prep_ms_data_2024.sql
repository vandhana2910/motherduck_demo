SELECT
    * EXCLUDE (Date_Range_Gross, Prev_Year_Range_Gross, Date,Metro_Rank,Rtk_Theatre_No,"#_Screens",
    Latitude,Longitude,Fiscal_Week_Count,Day_Count),

    -- Clean currency columns: strip $ and commas, cast to double
    CAST(REPLACE(REPLACE(Date_Range_Gross, '$', ''), ',', '') AS DOUBLE) AS date_range_gross,
    CAST(REPLACE(REPLACE(Prev_Year_Range_Gross, '$', ''), ',', '') AS DOUBLE) AS prev_year_range_gross,

    -- Clean date column
    CAST(Date AS DATE) AS date_clean,
    CAST(Metro_Rank AS STRING) AS Metro_Rank,
    CAST(Rtk_Theatre_No AS BIGINT) AS Rtk_Theatre_No,
    CAST("#_Screens" AS BIGINT) AS no_of_screens,
    CAST(Latitude AS DOUBLE) AS Latitude,
    CAST(Longitude AS DOUBLE) AS Longitude,
    CAST(Fiscal_Week_Count AS BIGINT) AS Fiscal_Week_Count,
    CAST(Date AS DATE) AS Date,
    CAST(Day_Count AS BIGINT) AS Day_Count,


FROM {{ ref('base_ms_data_2024') }}