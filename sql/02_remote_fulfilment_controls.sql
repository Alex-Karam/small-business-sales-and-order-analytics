-- Reconcile the January-October 2026 Fulfilment cards against MySQL.
-- Use the database containing v_orders. The query reads aggregate values.
-- The report applies the channel list as a page filter. Its DAX measures
-- count all methods in the denominator, including unknown and NULL methods.

WITH remote_orders AS (
    SELECT fulfilment_method
    FROM v_orders
    WHERE fulfilment_date >= '2026-01-01'
      AND fulfilment_date < '2026-11-01'
      AND ordering_channel IN (
          'facebook', 'instagram', 'sms / phone call', 'staff contact',
          'viber', 'website / email', 'whatsapp'
      )
)
SELECT
    COUNT(*) AS remote_order_count,
    ROUND(100.0 * COUNT(CASE WHEN fulfilment_method = 'delivery' THEN 1 END)
        / NULLIF(COUNT(*), 0), 2) AS delivery_pct,
    ROUND(100.0 * COUNT(CASE WHEN fulfilment_method = 'self-pickup' THEN 1 END)
        / NULLIF(COUNT(*), 0), 2) AS self_pickup_pct,
    ROUND(100.0 * COUNT(CASE
        WHEN fulfilment_method = 'unknown' OR fulfilment_method IS NULL THEN 1
    END) / NULLIF(COUNT(*), 0), 2) AS unrecorded_method_pct
FROM remote_orders;
