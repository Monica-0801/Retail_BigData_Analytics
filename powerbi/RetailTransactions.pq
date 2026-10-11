let
    Source = Csv.Document(
        File.Contents("C:\Users\monic\OneDrive\Desktop\Retail_BigData_Analytics\powerbi\retail_transactions.csv"),
        [Delimiter = ",", Columns = 11, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    TypedColumns = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"transaction_id", type text},
            {"transaction_date", type date},
            {"customer_id", type text},
            {"region", type text},
            {"product_category", type text},
            {"product_name", type text},
            {"quantity", Int64.Type},
            {"unit_price_inr", Int64.Type},
            {"discount_pct", Int64.Type},
            {"sales_amount_inr", Currency.Type},
            {"payment_method", type text}
        },
        "en-US"
    ),
    AddedMonthStart = Table.AddColumn(
        TypedColumns,
        "month_start",
        each Date.StartOfMonth([transaction_date]),
        type date
    )
in
    AddedMonthStart
