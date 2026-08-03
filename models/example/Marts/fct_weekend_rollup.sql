SELECT 
    venue,
    fiscal_week,
    SUM(Gross) AS weekend_gross,
    SUM(Industry) AS weekend_industry,
    ROUND(SUM(Gross) / SUM(Industry) *100,3) AS weekend_share,
    SUM(Py_Gross) AS py_weekend_gross,
    SUM(Py_Industry) AS Py_Industry,
    ROUND((SUM(Py_Gross) / SUM(Py_Industry)) *100,3) AS py_weekend_share,
    ROUND((SUM(Gross) / SUM(Industry) *100) - (SUM(Py_Gross) / SUM(Py_Industry)*100),3) AS weekend_delta
FROM {{ ref('fct_wtd_daily_combined') }}
WHERE day IN ('Friday', 'Saturday', 'Sunday')
GROUP BY venue,fiscal_week