# Implemented DAX measures

All 13 measure definitions were copied from the existing Power BI model on
9 November 2026 using `INFO.VIEW.MEASURES()` in DAX query view. Their home table
is `Orders`. The [definition catalogue](measures.dax) preserves the exported
formula logic; these are the report's implemented measures, not proposed replacements.

The catalogue contains individual measure definitions, not a single executable
query. The separate [Business overview validation query](validate_business_overview.dax)
runs against the existing model. Its 11 November 2026 results matched the
SQL totals and published comparisons. See [validation.md](../validation.md).

## Base measures and quality controls

| Measure | Calculation and purpose |
| --- | --- |
| `Total Orders` | `COALESCE(COUNTROWS(Orders), 0)` counts included reporting orders, including recorded zero-charge orders |
| `Unique Order Keys` | Distinct source-key count, used alongside row count to check the reporting grain |
| `Orders Missing Charges` | Counts blank charge values; unknown amounts are distinguished from recorded zeros |
| `Known Charges EUR` | Sums known `order_charge_eur` values |
| `Mean Known Order Charge EUR` | Averages known charge values; blank amounts are excluded and recorded zeros remain included |

Row counts and charge controls for January-October of both years are in
[validation.md](../validation.md). No unique-customer count is inferred from
either row count or source-key count.

## Matched-month year comparisons

`Orders YoY %`, `Known Charges YoY %` and `Mean Known Order Charge YoY %`:

1. Read the single year in the current filter context.
2. Capture the selected calendar month numbers.
3. Remove the calendar filters for the previous-period calculation.
4. Apply the previous year and the captured month numbers with `TREATAS`.
5. Divide the difference by the previous-period value with `DIVIDE`.

Other report filters, such as ordering channel, remain in context. A selection
containing multiple years has no single `CurrentYear`, so these measures return
blank. `DIVIDE` also leaves zero-denominator comparisons blank.

These measures implement a **month-based** comparison. Removing the whole
calendar also removes weekday and individual-date filters from the prior-year
calculation; only year and captured month numbers are reapplied. The published
report uses complete January-October month selections, not arbitrary matched-day
or rolling-period comparisons.

`Known Charges Change EUR` applies the same selected-month logic to an absolute
charge difference. It additionally checks the first calendar year and blank
amounts. An empty order context is treated as zero charges, while an existing
set of orders with unknown charges can remain blank. The measure therefore
distinguishes no orders from missing monetary information.

The mean-charge YoY measure compares the underlying averages. It does not
calculate the change from the two displayed means rounded to cents.

## Fulfilment shares and their report context

`Delivery Share %`, `Self-Pickup Share %` and `Unknown Fulfilment Share %`
use a method-specific numerator and an all-method denominator. The denominator
removes the filter on `Orders[fulfilment_method]` while retaining date, ordering
channel and other filters. The unknown numerator includes both `"unknown"` and
`BLANK()` method values.

The measures **do not define the remote-order cohort themselves**. The
Fulfilment page supplies the seven-channel filter: facebook, instagram,
sms / phone call, staff contact, viber, website / email and whatsapp. Shop,
marketplace and unknown ordering channels are excluded from that page's cohort.
Unknown fulfilment methods remain in its denominator.

The numerator's `CALCULATE` sets the method condition. This is the intended
page-level cohort calculation, not a measure designed to retain an arbitrary
existing filter on that same method column.

## Orders per comparison day

`Orders per Comparison Day` starts from the distinct calendar dates in the
current context and removes four confirmed closures: January 1 and June 24
in each of 2025 and 2026. It applies those dates to the order count with
`KEEPFILTERS`, then divides by the number of retained calendar dates.

The denominator counts calendar dates, not distinct dates observed in Orders.
Non-closure dates with zero orders therefore remain available in the
denominator. This also allows the weekday chart to use the number of selected
comparison dates for each weekday rather than an annual denominator.

Only those four confirmed closures are excluded. The measure does not infer
additional closures or treat all zero-order dates as closed days. The dates are
explicit constants for this report's study period, not a general holiday calendar.

## Formats and interpretation

The pasted metadata export had blank `Format string` cells. This catalogue
records the formulas without inventing format-string metadata. The report's
visible currency/percentage formatting was reviewed separately. Percentage
measure results are numeric fractions; the validation query formats them as
percentage text for reading, without changing the underlying definitions.

Order charges are recorded amounts, not profit or confirmed cash receipts.

## DAX references

The implementation source is the existing model. These Microsoft references
explain the filter and display functions used by the code:

- [CALCULATE](https://learn.microsoft.com/en-us/dax/calculate-function-dax)
- [REMOVEFILTERS](https://learn.microsoft.com/en-us/dax/removefilters-function-dax)
- [TREATAS](https://learn.microsoft.com/en-us/dax/treatas-function-dax)
- [FORMAT](https://learn.microsoft.com/en-us/dax/format-function-dax)
- [INFO.VIEW.MEASURES](https://learn.microsoft.com/en-us/dax/info-view-measures-function-dax)
