SELECT 
    vm.Venue AS venue,
    m2.Theatre_Name_Internal,
    CAST(fc.date AS DATE) AS date,
    fc.day,
    fc.fiscal_week,
    fc.fiscal_year,
    fc.day_count,
    m2.Date_Range_Gross AS Py_Gross,
    ROUND(i2.Industry) AS Py_Industry,
    (CAST(m2.Date_Range_Gross AS DOUBLE) / CAST(i2.Industry AS DOUBLE))*100 AS Py_share
FROM prep_ms_data_2024 m2
JOIN fiscal_calendar fc ON m2.Date = CAST(fc.date AS DATE)
JOIN prep_ms_industry_2024 i2 ON m2.Date = i2.Date
LEFT JOIN venue_map vm ON m2.Theatre_Name_Internal = vm.Theatre_Name_Internal
