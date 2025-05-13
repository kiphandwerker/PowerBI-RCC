section REDCapConnector;

// Reusable headers
headers = [
    #"Accept" = "text/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

// Core implementation with logicals hard-coded to true
REDCapConnectorImpl = (
    apiUrl as text,
    apiToken as text,
    rawOrLabel as text,
    rawOrLabelHeaders as text,
    fields as text,
    forms as text,
    events as text
) =>
    let
        postData = [
            token = apiToken,
            content = "record",
            format = "csv",
            type = "flat",
            rawOrLabel = rawOrLabel,
            rawOrLabelHeaders = rawOrLabelHeaders,
            exportCheckboxLabel = "true",
            exportSurveyFields = "true",
            exportDataAccessGroups = "true",
            fields = fields,
            forms = forms,
            events = events
        ],

        response = Web.Contents(apiUrl,
            [
                Headers = headers,
                Content = Text.ToBinary(Uri.BuildQueryString(postData))
            ]
        ),

        csv = Csv.Document(response, [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        table = Table.PromoteHeaders(csv, [PromoteAllScalars = true])
    in
        table;

// Add type signature
REDCapConnector_Typed = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        apiUrl as text,
        apiToken as text,
        rawOrLabel as text,
        rawOrLabelHeaders as text,
        fields as text,
        forms as text,
        events as text
    ) as table
);

// Metadata with required fields only (no logicals)
REDCapConnector_Documented = Value.ReplaceMetadata(REDCapConnector_Typed,
    [
        Documentation = [
            apiUrl = [
                Documentation.FieldCaption = "REDCap API URL",
                Documentation.FieldDescription = "The base URL to your REDCap API (e.g., https://redcap.example.com/api/).",
                Documentation.SampleValues = {"https://your-redcap/api/"}
            ],
            apiToken = [
                Documentation.FieldCaption = "API Token",
                Documentation.FieldDescription = "Your REDCap API token.",
                Documentation.SampleValues = {"ABC123TOKEN"}
            ],
            rawOrLabel = [
                Documentation.FieldCaption = "Raw or Label",
                Documentation.FieldDescription = "Return raw values or labels.",
                Documentation.AllowedValues = {"raw", "label", "both"}
            ],
            rawOrLabelHeaders = [
                Documentation.FieldCaption = "Header Format",
                Documentation.FieldDescription = "Header values format.",
                Documentation.AllowedValues = {"raw", "label"}
            ],
            fields = [
                Documentation.FieldCaption = "Fields",
                Documentation.FieldDescription = "Comma-separated field names to export.",
                Documentation.SampleValues = {"field1,field2"}
            ],
            forms = [
                Documentation.FieldCaption = "Forms",
                Documentation.FieldDescription = "Comma-separated form names to export.",
                Documentation.SampleValues = {"form1,form2"}
            ],
            events = [
                Documentation.FieldCaption = "Events",
                Documentation.FieldDescription = "Comma-separated event names to export.",
                Documentation.SampleValues = {"event1,event2"}
            ]
        ]
    ]
);

// Publish the function
[DataSource.Kind = "REDCapConnector", Publish = "REDCapConnector.Publish"]
shared REDCapConnector.Contents = REDCapConnector_Documented;

// Define the data source kind
REDCapConnector = [
    TestConnection = (dataSourcePath) => { "REDCapConnector.Contents", dataSourcePath },
    Authentication = [
        Implicit = []
    ],
    Label = "REDCap API Connector"
];

// Define how it shows up in Power BI
REDCapConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector", "Connect to REDCap" },
    LearnMoreUrl = "https://projectredcap.org"
];
