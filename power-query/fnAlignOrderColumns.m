(raw as table, hasPhoneColumn as logical) as table =>
let
    StandardFields = {
        "fulfilment_date_time_raw",
        "brand_raw",
        "buyer_name_or_username_raw",
        "ordering_channel_raw",
        "delivery_details_raw",
        "recipient_phone_raw",
        "order_description_raw",
        "balloons_amount_raw",
        "delivery_fee_raw",
        "packaging_charge_raw",
        "order_total_payable_raw",
        "payment_raw",
        "stock_reservation_note_raw"
    },

    LayoutFields =
        if hasPhoneColumn then StandardFields
        else List.RemoveItems(
            StandardFields,
            {"recipient_phone_raw"}
        ),

    SourceColumns = List.Transform(
        {1..List.Count(LayoutFields)},
        each "Column" & Text.From(_)
    ),

    WithSourceRow = Table.AddIndexColumn(
        raw, "source_row", 1, 1, Int64.Type
    ),

    Renamed = Table.RenameColumns(
        WithSourceRow,
        List.Zip({SourceColumns, LayoutFields})
    ),

    Aligned = Table.SelectColumns(
        Renamed,
        {"source_row"} & StandardFields,
        MissingField.UseNull
    )
in
    Aligned
