section REDCapConnector;

headers = [
    #"Accept" = "text/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

REDCapConnectorImpl = (
    REDCapURL as text,
    APItoken as text,
    optional rawOrLabel as any,
    optional rawOrLabelHeaders as any,
    optional exportCheckboxLabel as any,
    optional exportSurveyFields as any,
    optional exportDataAccessGroups as any,
    optional fields as any,
    optional forms as any,
    optional events as any
    ) =>
    let

        baseParams = [
            token = APItoken,
            content = "record",
            format = "csv",
            type = "flat",
            rawOrLabel = " ",
            rawOrLabelHeaders = " ",
            exportCheckboxLabel = " ",
            exportSurveyFields = " ",
            exportDataAccessGroups = " ",
            fields = " ",
            forms = " ",
            events = " "
        ],

        optionalParams = [
            rawOrLabel = if Text.Trim(rawOrLabel) <> "" then rawOrLabel else "raw",
            rawOrLabelHeaders = if Text.Trim(rawOrLabelHeaders) <> "" then rawOrLabelHeaders else "raw",
            exportCheckboxLabel = if Text.Trim(exportCheckboxLabel) <> "" then exportCheckboxLabel else "true",
            exportSurveyFields = if Text.Trim(exportSurveyFields) <> "" then exportSurveyFields else "true",
            exportDataAccessGroups = if Text.Trim(exportDataAccessGroups) <> "" then exportDataAccessGroups else "true",
            fields = if Text.Trim(fields) <> "" then fields else null,
            forms = if Text.Trim(forms) <> "" then forms else null,
            events = if Text.Trim(events) <> "" then events else null
        ],


        allParams = Record.RemoveFields(
            Record.Combine({baseParams, optionalParams}),
            List.Select(
                Record.FieldNames(optionalParams), each Record.Field(optionalParams, _) = null 
                )
            ),

        response = Web.Contents(REDCapURL,
            [Headers = headers,
            Content = Text.ToBinary(Uri.BuildQueryString(allParams))]
        ),

        csv = Csv.Document(response, [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        table = Table.PromoteHeaders(csv, [PromoteAllScalars = true])
    in
        table;

REDCapConnector_Typed = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        REDCapURL as text,
        APItoken as text,
        optional rawOrLabel as any,
        optional rawOrLabelHeaders as any,
        optional exportCheckboxLabel as any,
        optional exportSurveyFields as any,
        optional exportDataAccessGroups as any,
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
