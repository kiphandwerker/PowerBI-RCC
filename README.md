# Power BI to REDCap Custom Connector

This Power Query M custom connector enables streamlined access to data from a REDCap (Research Electronic Data Capture) project using the REDCap API. It supports customizable data pulls from fields, forms, and events, returning the results as a Power BI table.

# Table of Contents
- [Features](#features)
- [Usage](#usage)
    - [PowerBI](#usage-in-powerbi)
    - [Authentication](#authentication)
    - [REDCap](#usage-for-api-testing)
- [Parameters](#parameters)
- [Limitations](#limitations)

# Features

- Connects directly to REDCap projects via API
- Supports filtering by fields, forms, and events
- Retrieves survey fields, data access groups, and checkbox labels
- Returns data in a flat, tabular format
- Easily usable within Power BI or Excel via custom connector UI

# Usage
The files provided can offer usage in either PowerBI (`.mez`) or for your own testing with your REDCap API (`.pq`).

## Usage in PowerBI

To use the connector in Power BI:

1. Copy the `REDCap-PowerBI.mez` file (found in `bin\AnyCPU\Debug\`) to your Power BI custom connectors folder (e.g., `Documents\Power BI Desktop\Custom Connectors`).
2. Enable custom connectors in Power BI Desktop settings.
3. Restart Power BI Desktop.
4. Choose "REDCap Connector" from the `Get Data` screen under the "Other" category.
5. Enter your REDCap API URL (`REDCapULR`), token(`APItoken`)
- Optional parameters:
    - rawOrLabel (`rawOrLabel`)
    - rawOrLabelHeaders (`rawOrLabelHeaders`)
    - exportCheckboxLabel (`exportCheckboxLabel`)
    - exportSurveyFields (`exportSurveyFields`)
    - exportDataAccessGroups (`exportDataAccessGroups`)
    - field (`fields`)
    - form (`forms`)
    - event (`events`)

### Authentication

This connector uses anonymous authentication, with access secured via the REDCap API token.
UI Integration

- Appears under "Other" in Power BI's data source UI.
- UI label: "REDCap Connector"
 - Learn more link: https://projectredcap.org

## Usage for API testing

Required extensions:
- [Power Query / M Language](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery)
- [Power Query SDK](https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery-sdk)

To test your own API
- Start a new Power Query SDK extension project.
- Change `REDCapULR` and `APItoken`
- Set your credentials (Anonymous)
- Run TestConnection function


## Parameters
Required:
- `REDCapURL` – The full URL to your REDCap instance's API endpoint (e.g., https://redcap.institution.edu/api/).
- `APItoken` – The API token for the specific REDCap project.

Optional:
- `rawOrLabel` - raw or label
- `rawOrLabelHeaders`- raw or label
- `exportCheckboxLabel`- true or false
- `exportSurveyFields` - true or false
`exportDataAccessGroups` - true or false
- `fields` - Comma-separated list of specific fields to retrieve.
- `forms` - Comma-separated list of specific forms to retrieve.
- `events` - Comma-separated list of events (for longitudinal projects).

If `rawOrLabel` or `rawOrLabelHeaders` are not specified they default to raw.

If `exportCheckboxLabel`, `exportCheckboxLabel`, or `exportDataAccessGroups` are not specified they default to true.

If `fields`, `forms`, or `events` are not specified or are empty strings the connector retrieves all available data by default.

# Limitations
- Only supports CSV-formatted data.
- Expects UTF-8 encoding for proper parsing.
- Does not support paginated responses or file uploads/downloads.


