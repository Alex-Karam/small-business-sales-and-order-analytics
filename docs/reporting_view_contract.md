# Reporting-view input contract

## Purpose and grain

Power BI imports an existing MySQL reporting view named `v_orders`. Its grain
is one row per included reporting order after the reviewed upstream source
corrections, exclusions and grouping. Retained raw/clean source entries and
included reporting orders therefore need not have the same count.

The two SQL examples use the following fields from the reporting view.

| Field | Meaning | Requirement |
| --- | --- | --- |
| `source_record_key` | Source-derived key used to trace an order internally | One non-NULL, unique key per included reporting order; actual key values remain private |
| `fulfilment_date` | Date when the order was due to be fulfilled | MySQL date used by both queries |
| `order_charge_eur` | Reviewed recorded order charge in euros | Numeric. Zero is a recorded zero charge. NULL means an unknown amount |
| `ordering_channel` | Reviewed channel classification | Text used to select the seven remote channels |
| `fulfilment_method` | Reviewed fulfilment method | `delivery`, `self-pickup`, or `unknown`. The remote query also includes NULL in the unrecorded category |

## Business overview scope

- January-October in each of 2025 and 2026, using fulfilment dates.
- All included ordering channels and fulfilment methods.
- SQL row count checked against distinct source-key count.
- Charge sum and mean calculated from known charges. Missing amounts are counted
  separately.

## Remote fulfilment scope

- January-October 2026, using fulfilment dates and the Fulfilment page's seven
  remote ordering channels.
- All orders in that cohort contribute to the denominator. The unrecorded
  numerator includes both `unknown` and NULL methods.
- The separate orders-per-comparison-day measure applies the confirmed closure
  exclusions when constructing its calendar denominator.

Select the appropriate database in your MySQL client before running the query.
No private database name, connection credentials or source-key literals are
required in this public code file.

The private view is supplied by the implemented cleaning and reporting layer.
This example does not include the underlying customer records, historical
record-specific decisions or a standalone database build.
