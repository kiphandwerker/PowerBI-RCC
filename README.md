# Power BI to REDCap Custom Connector (Power Query M Extension)

This Power Query M custom connector enables streamlined access to data from a REDCap (Research Electronic Data Capture) project using the REDCap API. It supports customizable data pulls from fields, forms, and events, returning the results as a Power BI table.

# Table of Contents
- [Features](#features)
- [Usage](#usage)
- [Parameters](#parameters)
- [Authentication](#authentication)
- [Limitations](#limitations)

## Features

- Connects directly to REDCap projects via API
- Supports filtering by fields, forms, and events
- Retrieves survey fields, data access groups, and checkbox labels
- Returns data in a flat, tabular format
- Easily usable within Power BI or Excel via custom connector UI

## Usage

To use the connector in Power BI:

1. Copy the `REDCap-PowerBI.mez` file (found in `bin\AnyCPU\Debug\`) to your Power BI custom connectors folder (e.g., `Documents\Power BI Desktop\Custom Connectors`).
2. Enable custom connectors in Power BI Desktop settings.
3. Restart Power BI Desktop.
4. Choose "REDCap Connector" from the `Get Data` screen under the "Other" category.
5. Enter your REDCap API URL (`REDCapULR`), token(`APItoken`), and optionally specify field (`fields`), form (`forms`), or event (`events`) filters.

## Parameters

- `REDCapURL` – The full URL to your REDCap instance's API endpoint (e.g., https://redcap.institution.edu/api/).
- `APItoken` – The API token for the specific REDCap project.
- `fields` (optional) – Comma-separated list of specific fields to retrieve.
- `forms` (optional) – Comma-separated list of specific forms to retrieve.
- `events` (optional) – Comma-separated list of events (for longitudinal projects).

If `fields`, `forms`, or `events` are not specified or are empty strings, the connector retrieves all available data by default.

### Note:
In order to avoid a cluttered interface upon launch the following are hard coded:
- rawOrLabel = "raw",
- rawOrLabelHeaders = "raw",
- exportCheckboxLabel = "true",
- exportSurveyFields = "true",
- exportDataAccessGroups = "true",
## Authentication

This connector uses anonymous authentication, with access secured via the REDCap API token.
UI Integration

- Appears under "Other" in Power BI's data source UI.
- UI label: "REDCap Connector"
 - Learn more link: https://projectredcap.org

## Limitations
- Only supports CSV-formatted data.
- Expects UTF-8 encoding for proper parsing.
- Does not support paginated responses or file uploads/downloads.


