SELECT 
    venue,
    fiscal_week,
    SUM(gross) AS wtd_gross,
    SUM(industry) AS wtd_industry,
    ROUND((SUM(gross) / SUM(industry))*100,3) AS wtd_share,
    SUM(py_gross) AS py_wtd_gross,
    SUM(Py_Industry) AS py_wtd_industry,
    ROUND((SUM(py_gross) / SUM(py_industry))*100,3) AS py_wtd_share,
    ROUND((SUM(gross) / SUM(industry)*100) - (SUM(py_gross) / SUM(py_industry)*100),3) AS wtd_delta
FROM {{ ref('fct_wtd_daily_combined') }}
GROUP BY venue,fiscal_week