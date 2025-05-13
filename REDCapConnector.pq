// REDCap API Connector
section REDCapConnector;

// Define headers
headers = [
    #"Accept" = "text/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

// Core function implementation
REDCapConnectorImpl = (
    REDCapURL as text,
    APItoken as text,
    fields as text,
    forms as text,
    events as text
) =>
    let
        postData = [
            token = APItoken,
            content = "record",
            format = "csv",
            type = "flat",
            rawOrLabel = "raw",
            rawOrLabelHeaders = "raw",
            exportCheckboxLabel = "true",
            exportSurveyFields = "true",
            exportDataAccessGroups = "true",
            fields = fields,
            forms = forms,
            events = events
        ],

        response = Web.Contents(REDCapURL,
            [
                Headers = headers,
                Content = Text.ToBinary(Uri.BuildQueryString(postData))
            ]
        ),

        csv = Csv.Document(response, [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        table = Table.PromoteHeaders(csv, [PromoteAllScalars = true])
    in
        table;

// Apply type signature
REDCapConnector_Typed = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        REDCapURL as text,
        APItoken as text,
        fields as text,
        forms as text,
        events as text
    ) as table
);

// Apply metadata for correct UI placeholders
// REDCapConnector_Documented = Value.ReplaceMetadata(REDCapConnector_Typed,
//     [
//         Documentation = [
//             REDCapURL = [
//                 Documentation.FieldCaption = "REDCap API URL",
//                 Documentation.FieldDescription = "The base URL to your REDCap API.",
//                 Documentation.SampleValues = {"https://redcap.example.com/api/"}
//             ],
//             APItoken = [
//                 Documentation.FieldCaption = "API Token",
//                 Documentation.FieldDescription = "Your REDCap API token.",
//                 Documentation.SampleValues = {"ABC123TOKEN"}
//             ],
//             fields = [
//                 Documentation.FieldCaption = "Fields",
//                 Documentation.FieldDescription = "Comma-separated field names to export.",
//                 Documentation.SampleValues = {"record_id,age,gender"}
//             ],
//             forms = [
//                 Documentation.FieldCaption = "Forms",
//                 Documentation.FieldDescription = "Comma-separated form names to export.",
//                 Documentation.SampleValues = {"demographics_form,visit_form"}
//             ],
//             events = [
//                 Documentation.FieldCaption = "Events",
//                 Documentation.FieldDescription = "Comma-separated event names to export.",
//                 Documentation.SampleValues = {"baseline_event,followup_event"}
//             ]
//         ]
//     ]
// );

// Publish the function
[DataSource.Kind = "REDCapConnector", Publish = "REDCapConnector.Publish"]
shared REDCapConnector.Contents = REDCapConnector_Typed; // REDCapConnector_Documented;

// Define the data source kind
REDCapConnector = [
    TestConnection = (dataSourcePath) => { "REDCapConnector.Contents", dataSourcePath },
    Authentication = [
        Implicit = []
    ],
    Label = "REDCap API Connector"
];

// Define connector appearance in Power BI UI
REDCapConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector", "Connect to REDCap" },
    LearnMoreUrl = "https://projectredcap.org"
];
