section REDCapConnector;

headers = [
    #"Accept" = "text/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

// These are what show up for input
REDCapConnectorImpl = (
    REDCapURL as text,
    APItoken as text,
    // rawOrLabel as text,
    // rawOrLabelHeaders as text,
    optional fields as any,
    optional forms as any,
    optional events as any
) =>
    let
        // Build POST content string conditionally
        baseParams = [
            token = APItoken,
            content = "record",
            format = "csv",
            type = "flat",
            rawOrLabel = "raw", // rawOrLabel
            rawOrLabelHeaders = "raw", // rawOrLabelHeaders
            exportCheckboxLabel = "true",
            exportSurveyFields = "true",
            exportDataAccessGroups = "true",
            fields = " ",
            forms = " ",
            events = " "
        ],

        optionalParams = [
            fields = if Text.Trim(fields) <> "" then fields else null,
            forms = if Text.Trim(forms) <> "" then forms else null,
            events = if Text.Trim(events) <> "" then events else null
        ],

        // Merge dictionaries, filter out nulls
        allParams = Record.RemoveFields(Record.Combine({baseParams, optionalParams}), List.Select(Record.FieldNames(optionalParams), each Record.Field(optionalParams, _) = null)),

        response = Web.Contents(REDCapURL,
            [
                Headers = headers,
                Content = Text.ToBinary(Uri.BuildQueryString(allParams))
            ]
        ),

        csv = Csv.Document(response, [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        table = Table.PromoteHeaders(csv, [PromoteAllScalars = true])
    in
        table;


REDCapConnector_Typed = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        REDCapURL as text,
        APItoken as text,
        optional fields as text,
        optional forms as text,
        optional events as text
    ) as table
);


[DataSource.Kind = "REDCapConnector", Publish = "REDCapConnector.Publish"]
shared REDCapConnector.Contents = REDCapConnector_Typed;


REDCapConnector = [
    TestConnection = (dataSourcePath) => { "REDCapConnector.Contents", dataSourcePath },
    Authentication = [
        Anonymous = []
    ],
    Label = "REDCap API Connector"
];


REDCapConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector", "Connect to REDCap" },
    LearnMoreUrl = "https://projectredcap.org"
];
