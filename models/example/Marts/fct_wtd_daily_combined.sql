SELECT 
    cy.venue,
    cy.date,
    cy.day,
    cy.fiscal_week,
    cy.day_count,
    CAST(cy.Gross AS DOUBLE) AS Gross,
    cy.Industry,
    ROUND(cy.share,3) AS share,
    CAST(py.Py_Gross AS DOUBLE) AS Py_Gross,
    py.Py_Industry,
    ROUND(py.Py_share,3) AS Py_share,
    ROUND(cy.share - py.Py_share,3) AS delta
FROM {{ ref('fct_current_year_rev_daily') }} cy
LEFT JOIN {{ ref('fct_prior_year_rev_daily') }} py
    ON cy.Theatre_Name_Internal = py.Theatre_Name_Internal
   AND cy.day_count = py.day_count
--WHERE cy.fiscal_week = 'P12W2'
ORDER BY cy.venue, cy.date