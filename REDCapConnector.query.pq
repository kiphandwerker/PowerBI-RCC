section TestQuery;

shared TestQuery = let
    REDCapURL = "url",
    APItoken = "apikey",
    data = REDCapConnector.Contents(REDCapURL, APItoken) 
    // Required
        // REDCapURL
        // APItoken
    // Optional
        // rawOrLabel             (default: raw)
        // rawOrLabelHeaders      (default: raw)
        // exportCheckboxLabel    (default: true)
        // exportSurveyFields     (default: true)
        // exportDataAccessGroups (default: true) 
        // fields                 (default: )
        // forms                  (default: )
        // events                 (default: )  
in
    data;
