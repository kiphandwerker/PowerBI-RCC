section REDCapConnector;

// Reusable headers
headers = [
    #"Accept" = "text/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

// Core implementation with flexible parameters
REDCapConnectorImpl = (
    apiUrl as text,
    apiToken as text,
    rawOrLabel as text,
    rawOrLabelHeaders as text,
    exportCheckboxLabel as text,
    exportSurveyFields as text,
    exportDataAccessGroups as text,
    fields as nullable text,
    forms as nullable text,
    events as nullable text
) =>
    let
        postData = [
            token = apiToken,
            content = "record",
            format = "csv",
            type = "flat",
            rawOrLabel = rawOrLabel,
            rawOrLabelHeaders = rawOrLabelHeaders,
            exportCheckboxLabel = exportCheckboxLabel,
            exportSurveyFields = exportSurveyFields,
            exportDataAccessGroups = exportDataAccessGroups
        ] 
        & (if fields <> null then [fields = fields] else [])
        & (if forms <> null then [forms = forms] else [])
        & (if events <> null then [events = events] else []),

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

// Type declaration only (no metadata here)
REDCapConnector_Typed = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        apiUrl as text,
        apiToken as text,
        rawOrLabel as text,
        rawOrLabelHeaders as text,
        exportCheckboxLabel as text,
        exportSurveyFields as text,
        exportDataAccessGroups as text,
        fields as nullable text,
        forms as nullable text,
        events as nullable text
    ) as table
);

// Attach documentation metadata separately
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
            exportCheckboxLabel = [
                Documentation.FieldCaption = "Export Checkbox Labels?",
                Documentation.FieldDescription = "Should checkbox values use labels?",
                Documentation.AllowedValues = {"true", "false"}
            ],
            exportSurveyFields = [
                Documentation.FieldCaption = "Include Survey Fields?",
                Documentation.FieldDescription = "Should survey metadata fields be included?",
                Documentation.AllowedValues = {"true", "false"}
            ],
            exportDataAccessGroups = [
                Documentation.FieldCaption = "Include DAGs?",
                Documentation.FieldDescription = "Include Data Access Groups field?",
                Documentation.AllowedValues = {"true", "false"}
            ],
            fields = [
                Documentation.FieldCaption = "Fields (optional)",
                Documentation.FieldDescription = "Comma-separated field names to export.",
                Documentation.SampleValues = {"field1,field2"}
            ],
            forms = [
                Documentation.FieldCaption = "Forms (optional)",
                Documentation.FieldDescription = "Comma-separated form names to export.",
                Documentation.SampleValues = {"form1,form2"}
            ],
            events = [
                Documentation.FieldCaption = "Events (optional)",
                Documentation.FieldDescription = "Comma-separated event names to export.",
                Documentation.SampleValues = {"event1,event2"}
            ]
        ]
    ]
);

// Publish function with metadata
[DataSource.Kind = "REDCapConnector", Publish = "REDCapConnector.Publish"]
shared REDCapConnector.Contents = REDCapConnector_Documented;

// Data Source Kind
REDCapConnector = [
    TestConnection = (dataSourcePath) => { "REDCapConnector.Contents", dataSourcePath },
    Authentication = [
        Implicit = []
    ],
    Label = "REDCap API Connector"
];

// Publish info for Power BI
REDCapConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector", "Connect to REDCap" },
    LearnMoreUrl = "https://projectredcap.org"
];
