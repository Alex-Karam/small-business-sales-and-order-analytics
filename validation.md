# SQL and Power BI validation

## First example: Business overview

**Status: verified on 9 November 2026.** The extracted SQL was executed in MySQL
Workbench against the project's final reporting view. Its two result rows match
all previously checked Power BI controls below: order count, distinct keys,
missing charges, known-charge sum and mean. The result grid and successful
two-row execution were reviewed from the user's screenshot.

Scope: fulfilment dates in January-October of each year, all reporting channels,
with no additional chart or slicer selection.

| Year | Total orders | Unique order keys | Missing charges | Known charges EUR | Mean known charge EUR |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2025 | 3,218 | 3,218 | 0 | 157,462.57 | 48.93 |
| 2026 | 3,005 | 3,005 | 0 | 154,309.60 | 51.35 |

SQL file: [01_business_overview_controls.sql](sql/01_business_overview_controls.sql).

The equality between rows and distinct keys checks the expected reporting
grain. Missing-charge counts distinguish genuine recorded zeros from unknown
amounts. Monetary values are rounded only for display; the mean is calculated
from the underlying charge values.

These are real, owner-approved aggregate report controls, not synthetic results.

## Completed check

The extracted query returned exactly the two rows above. Counts match distinct
keys in both years, and missing charges are zero. No database objects or source
records were changed by the query.

## Power BI relationship - verified

On 9 November 2026, the existing Model view and Edit relationship dialog
confirmed an active, single-direction relationship from
`Fulfilment Calendar[Date]` (one side) to `Orders[fulfilment_date]` (many side).
The dialog reports Many to one (*:1) when opened from Orders. See the
[model documentation and actual diagram](docs/power-bi-model.md).

The public companion will distinguish executed checks from illustrative or
unexecuted examples. It does not provide the private row-level dataset.

## Actual DAX definitions - captured

On 9 November 2026, all 13 existing `Orders` measures were copied from the
model's `INFO.VIEW.MEASURES()` results. The full formulas and their context are
documented in [DAX measures](dax/measures.md). The metadata export's format-string
cells were blank; no missing format strings were reconstructed.

## DAX control query verified on 11 November 2026

[validate_business_overview.dax](dax/validate_business_overview.dax) groups by
calendar year and explicitly selects January-October in 2025 and 2026. It calls
the existing measures without redefining them. It includes the SQL-compatible
base controls above and the published 2026 comparison results below.

The user ran the query in Power BI Desktop. It returned two rows and ten
columns. The base metrics matched the SQL table above for both years.

| 2026 comparison | Observed result |
| --- | ---: |
| Orders YoY | -6.62% |
| Known charges YoY | -2.00% |
| Mean known order charge YoY | 4.94% |
| Known charges change EUR | -3152.97 |

The four 2025 comparison cells were blank, as expected for the earliest year
in the model.

## Remote fulfilment SQL check verified on 11 November 2026

[02_remote_fulfilment_controls.sql](sql/02_remote_fulfilment_controls.sql) uses
the seven remote channels and January-October 2026 scope of the Fulfilment
page. Unknown and blank fulfilment methods count in the denominator.

| Remote orders | Delivery | Self-pickup | Unrecorded method |
| ---: | ---: | ---: | ---: |
| 1,690 | 59.17% | 38.22% | 2.60% |

The user ran the query in MySQL Workbench. Its single result row matched the
four published card values above at their displayed precision. The shares
are rounded independently.
