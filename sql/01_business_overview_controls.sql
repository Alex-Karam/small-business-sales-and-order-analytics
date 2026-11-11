-- Small Business Sales and Order Analytics
-- Business overview: matched January-October controls.
--
-- Run in MySQL against the selected database containing v_orders.
-- Required columns: fulfilment_date, source_record_key, order_charge_eur.
-- Read-only: no table, view or source-record changes.
--
-- This publication extract uses the final reporting view imported into Power BI.
-- It combines the implemented matched-month scope and base aggregation logic.
-- Source-specific corrections and exclusions are upstream of this view and are
-- deliberately not reproduced as private record-level instructions here.
--
-- Count all included orders. SUM/AVG ignore NULL charges; recorded zeros remain
-- included. Report missing charges explicitly rather than treating them as zero.
-- This is an order/charge control, not the closure-adjusted daily-average measure.

WITH period_orders AS (
    SELECT
        YEAR(fulfilment_date) AS reporting_year,
        source_record_key,
        order_charge_eur
    FROM v_orders
    WHERE fulfilment_date >= '2025-01-01'
      AND fulfilment_date < '2026-11-01'
      AND MONTH(fulfilment_date) <= 10
)
SELECT
    reporting_year,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT source_record_key) AS unique_order_keys,
    COUNT(*) - COUNT(order_charge_eur) AS orders_missing_charges,
    ROUND(SUM(order_charge_eur), 2) AS known_charges_eur,
    ROUND(AVG(order_charge_eur), 2) AS mean_known_order_charge_eur
FROM period_orders
GROUP BY reporting_year
ORDER BY reporting_year;
