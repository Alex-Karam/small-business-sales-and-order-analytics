# Aligning monthly order worksheets

The [column alignment function](fnAlignOrderColumns.m) comes from the Excel
Power Query staging workflow. The standalone file preserves the saved function
body and uses the function-expression form accepted by the Advanced Editor.

The function accepts a raw table with positional columns such as `Column1`
and a `hasPhoneColumn` flag. The flag identifies whether the input layout has
a recipient phone column in the sixth position. The function adds `source_row`
before any later filtering and renames the positional columns according to the
specified layout. It then selects the same output columns for both layouts.
When the input layout omits the phone column, `MissingField.UseNull` supplies a
null phone field in the output so the monthly results can be appended.

| Input layout | `Column6` becomes | Output phone field |
| --- | --- | --- |
| With phone column | `recipient_phone_raw` | Original value |
| Without phone column | `order_description_raw` | Null |

The caller supplies the layout flag and the expected positional columns. In the
project, `source_row` was checked against worksheet rows before later staging
filters. The extract contains field names and transformation logic. The source
workbooks and source values remain private under the project's release scope.
