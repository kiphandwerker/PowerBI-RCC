section REDCapConnector;

[DataSource.Kind="REDCapConnector", Publish="REDCapConnector.Publish"]
shared REDCapConnector.Contents = (apiUrl as text, apiToken as text) =>
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
                    Headers = [#"Content-Type"="application/x-www-form-urlencoded"],
                    Content = Text.ToBinary(Uri.BuildQueryString(postData))
                ]
            )
        )
    in
        response;

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
    // SourceImage = REDCapConnector.Icons,
    // SourceTypeImage = REDCapConnector.Icons
];

// REDCapConnector.Icons = [
//     Icon16 = { Extension.Contents("REDCap16.png"), Extension.Contents("REDCap20.png") },
//     Icon32 = { Extension.Contents("REDCap32.png"), Extension.Contents("REDCap40.png") }
// ];
