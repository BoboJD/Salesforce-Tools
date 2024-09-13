# Unlocked Package Overview

The unlocked package includes the following components, grouped by functionality:

## Global Development Tools

- **OrgSettings**: Manage values that change based on the org type (e.g., different endpoint URLs for sandbox vs. production environments).
- **TokenManager**: Manages API access tokens stored in the org cache.
- **Logging System**: Logs API, LWC, and Apex errors into a custom object (`tlz__Log__c`).
- **Permission Sets**: Automatically assigned based on the user profile to manage access permissions.
- **SObjectHistory**: Tracks changes to any SObject.

## Apex Tools

- **fflib-apex-common & fflib-apex-mocks**: Libraries that have been modified to change protected and public properties/methods to global, making them usable within an unlocked package. These libraries provide common patterns for Apex development.
- **Apex Utility Methods**: A collection of methods to simplify Apex development.
- **Mocking API Calls**: Includes `MockHttpResponseGenerator` to mock API calls in tests and `TestUtils.setMock()` to define the mock behavior.
- **Apex Services**: Includes services such as `ConnectApiService`, `CustomNotificationService`, `DatabaseService`, `EmailTemplateService`, `FeatureManagementService`, `MessagingService`, and `OrganizationsService`.
- **SObjectCheckbox**: Provides functionality to uncheck a checkbox field.
- **RollupHelper**: Performs rollup summary calculations on lookup fields within triggers.

## LWC Tools

- **LWC Utility Methods**: Utility methods located in the `utils` Lightning Web Component, designed to enhance LWC development.
- **LWC Components**: Includes commonly used components such as `alert`, `datatable`, `disablePullToRefresh`, `fileUploader`, `filter`, `htmlEditor`, `modal`, and `spinner`.
- **LWC Form Components**: Includes form-related components like `input`, `lookup`, `picklist`, and `section`.
- **File Upload Handling**: Enabled file typing in Salesforce through the `fileUploader` Lightning Web Component and a custom metadata type `FileTypeConfiguration__mdt`.

## DevOps and Automation Tools

- **Bash Scripts**: Tools for managing org metadata files (retrieve and deploy), scratch org creation, and repository management.
