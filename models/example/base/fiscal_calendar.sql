-- ============================================================================
-- Fiscal Calendar Model (4-4-5 retail calendar) — COMPILED / verified version
-- ============================================================================
-- Rule confirmed from source data:
--   1. Fiscal week = Friday -> Thursday (7 days), always.
--   2. Fiscal year start = the Friday on/before Dec 31 of a given year.
--      Whichever Fri-Thu week contains Dec 31 becomes Period 1 / Week 1
--      of the NEW fiscal year (even if some of its days are in Dec of the
--      prior calendar year).
--   3. Weeks count up continuously from that start: 1, 2, 3 ... 52 (or 53).
--   4. Periods follow 4-4-5 weeks-per-period, repeating each quarter:
--        Period 1 = 4 weeks | Period 2 = 4 weeks | Period 3 = 5 weeks  (Q1, 13 wks)
--        Period 4 = 4 weeks | Period 5 = 4 weeks | Period 6 = 5 weeks  (Q2, 13 wks)
--        ... and so on through Period 12.
--
-- Verified against source rows:
--   27-12-2024 Fri -> P1W1,  count 1
--   02-01-2025 Thu -> P1W1,  count 1
--   03-01-2025 Fri -> P1W2,  count 2
--   02-12-2025 Tue -> P12W2, count 49
-- ============================================================================

with anchors as (
    -- For each candidate calendar year, find the Friday on/before Dec 31.
    -- That Friday is the fiscal-year-start date for the fiscal year that
    -- "owns" that Dec 31.
    select
        y as ref_year,
        cast(y || '-12-31' as date) as dec31,
        cast(y || '-12-31' as date)
            - cast(((dayofweek(cast(y || '-12-31' as date)) - 5 + 7) % 7) as integer)
            as fiscal_year_start
    from (select unnest([2022, 2023, 2024, 2025, 2026, 2027]) as y)
),

spine as (
    select unnest(
        generate_series(cast('2024-01-01' as date), cast('2026-12-31' as date), interval 1 day)
    ) as calendar_date
),

-- Assign every date to its fiscal year by picking the latest anchor
-- start date that is still <= the date.
dated as (
    select
        s.calendar_date,
        (
            select max(a.fiscal_year_start)
            from anchors a
            where a.fiscal_year_start <= s.calendar_date
        ) as fiscal_year_start
    from spine s
),

week_calc as (
    select
        calendar_date,
        fiscal_year_start,
        cast(
            floor(date_diff('day', fiscal_year_start, calendar_date) / 7) + 1
            as integer
        ) as fiscal_week_number
    from dated
),

period_calc as (
    select
        *,
        cast(ceil(fiscal_week_number / 13.0) as integer) as fiscal_quarter,
        case
            when ((fiscal_week_number - 1) % 13) between 0 and 3 then 1
            when ((fiscal_week_number - 1) % 13) between 4 and 7 then 2
            else 3
        end as period_in_quarter
    from week_calc
),

final as (
    select
        cast(calendar_date as date) as date,
        dayname(calendar_date) as day,
        year(fiscal_year_start) + 1 as fiscal_year,   -- label FY by the year it runs into
        fiscal_quarter,
        cast((fiscal_quarter - 1) * 3 + period_in_quarter as integer) as period_number,
        fiscal_week_number,
        cast(
            case
                when period_in_quarter = 1 then fiscal_week_number - ((fiscal_quarter - 1) * 13)
                when period_in_quarter = 2 then fiscal_week_number - (((fiscal_quarter - 1) * 13) + 4)
                else fiscal_week_number - (((fiscal_quarter - 1) * 13) + 8)
            end
            as integer
        ) as week_in_period,
        cast(date_diff('day', fiscal_year_start, calendar_date) + 1 as integer) as day_count
    from period_calc
)

select
    date,
    day,
    fiscal_year,
    fiscal_quarter,
    'Period ' || cast(period_number as varchar) as period,
    'P' || cast(period_number as varchar) || 'W' || cast(week_in_period as varchar) as fiscal_week,
    fiscal_week_number as fiscal_week_count,
    day_count
from final
order by date