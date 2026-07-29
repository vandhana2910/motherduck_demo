--Current-year daily revenue (Gross, Industry, Share) 
SELECT 
    vm.Venue AS venue,
    m.Theatre_Name_Internal,
    CAST(fc.date AS DATE) AS date,
    fc.day,                -- e.g. 'Friday'
    fc.fiscal_week,        -- e.g. 'P12W2'
    fc.fiscal_year,
    fc.day_count,
    m.Date_Range_Gross AS Gross,
    ROUND(i.Industry) AS Industry,
    (CAST(m.Date_Range_Gross AS DOUBLE) / CAST(i.Industry AS DOUBLE))*100 AS share
FROM prep_ms_data m
JOIN fiscal_calendar fc ON m.Date = fc.date
JOIN prep_ms_industry i ON m.Date = i.Date
LEFT JOIN venue_map vm ON m.Theatre_Name_Internal = vm.Theatre_Name_Internal
