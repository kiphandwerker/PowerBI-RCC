section REDCapConnector;

// Implementation function (not exported directly)
REDCapConnectorImpl = (apiUrl as text, apiToken as text) =>
    let
        postData = [
            token = apiToken,
            content = "record",
            format = "json",
            type = "flat"
        ],
        response = Json.Document(
            Web.Contents(apiUrl,
                [
                    Headers = [#"Content-Type" = "application/x-www-form-urlencoded"],
                    Content = Text.ToBinary(Uri.BuildQueryString(postData))
                ]
            )
        )
    in
        response;

// Shared function with type definition and documentation
[DataSource.Kind="REDCapConnector", Publish="REDCapConnector.Publish"]
shared REDCapConnector.Contents = Value.ReplaceType(REDCapConnectorImpl,
    type function (
        apiUrl as (type text meta [
            Documentation.FieldCaption = "REDCap API URL",
            Documentation.FieldDescription = "The base URL of the REDCap API (e.g., https://redcap.example.com/api/)",
            Documentation.SampleValues = {"https://your-redcap/api/"}
        ]),
        apiToken as (type text meta [
            Documentation.FieldCaption = "API Token",
            Documentation.FieldDescription = "Your REDCap API token",
            Documentation.SampleValues = {"ABC123TOKEN"}
        ])
    ) as list
);

// Data Source Kind description
REDCapConnector = [
    TestConnection = (dataSourcePath) => { "REDCapConnector.Contents", dataSourcePath },
    Authentication = [
        Implicit = []
    ],
    Label = "REDCap API Connector"
];

// Data Source UI publishing description
REDCapConnector.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector", "Connect to REDCap" },
    LearnMoreUrl = "https://projectredcap.org"
    // Optional: Uncomment and provide actual image files if using icons
    // SourceImage = REDCapConnector.Icons,
    // SourceTypeImage = REDCapConnector.Icons
];

// Optional: Icon definitions (uncomment if icons are added to the project)
// REDCapConnector.Icons = [
//     Icon16 = { Extension.Contents("REDCap16.png"), Extension.Contents("REDCap20.png") },
//     Icon32 = { Extension.Contents("REDCap32.png"), Extension.Contents("REDCap40.png") }
// ];
