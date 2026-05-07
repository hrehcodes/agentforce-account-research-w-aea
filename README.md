# Agentforce - Account Research w AEA

An Agentforce account research variant that uses Agentforce Employee Actions and a queueable Apex launcher to build Account Research Report records asynchronously.

This repository contains the Salesforce DX source retrieved from the `Agentforce - Account Research w AEA` unmanaged 1GP package hosted in the `pamigration` org. It is intended to be deployable as source-controlled metadata and to serve as implementation documentation for the solution.

## Solution Highlights
- Uses a queueable job to launch Agentforce_Account_Research_Report_Creator_Flow_AEA.
- Includes Agentforce topics/plugins, including an in-depth web research topic that delegates to EmployeeCopilot__WebSearch.
- Shares the Account_Research_Report__c data model and report prompt templates with the base account research solution.

## Architecture
Typical execution path:

1. An Agentforce action or topic receives a user request.
2. The action invokes a Flow, Prompt Builder template, or Apex invocable target.
3. Supporting Apex, Prompt Builder templates, and Salesforce metadata perform the callout, extraction, generation, formatting, or record update.
4. The result is returned to Agentforce or stored in Salesforce records for follow-up work.

## Metadata Inventory
- GenAiFunctions: `Agentforce_Account_Research_Task`, `Start_AEA_Account_Research_Report`
- GenAiPlugins/topics: `Agentforce_Account_Research_AEA`, `In_Depth_Web_Research`
- Prompt templates: `Account_Intelligence_Research_Report_Comparison`, `Account_Intelligence_Research_Report_Generator`, `Account_Intelligence_Research_Summarizer`, `Agentforce_Account_Research_Task`, `Source_Counter`
- Flows: `Agentforce_Account_Research_Report_Creator_Flow_AEA`, `Agentforce_Account_Research_Report_Creator_Maintain_Most_Recent_Flag`, `Agentforce_Account_Research_Task`
- Apex classes: `AEA_Account_Research_Flow_Starter`, `AEA_Account_Research_Queueable`
- Custom objects: `Account_Research_Report__c`
- Flexipages: `Enhanced_Account_Research_Report_Record_Page`
- Layouts: `Account_Research_Report__c-Account Research Report Layout`
- Notifications: `Account_Research_Complete_Notification`
- UI format sets: `Comparison_to_Previous_Report`

## Agentforce Actions and Topics
- `Agentforce_Account_Research_Task` -> `Agentforce_Account_Research_Task` (flow) - This action takes an account ID and question/task about an Agentforce Account Research Report and answers/performs the task.
- `Start_AEA_Account_Research_Report` -> `AEA_Account_Research_Flow_Starter` (apex) - Enqueues the AEA Research Flow for the given Account Id.
- Topic `Agentforce_Account_Research_AEA` - This topic is about enabling the agent to perform research on accounts to obtain specific information that will be helpful to a seller. The agent is capable of accessing up-to-date information on recent news, competitive positioning, and other valuable information about an account that will help a seller. This topic also allows the agent to answer questions about the account that come from the account research reports. The overall goal of this topic is to help sellers perform account research tasks that will speed up the selling process and make it more personal. Functions: `Agentforce_Account_Research_Task`, `EmployeeCopilot__GetRecordDetails`, `schema_ai__IdentifyObjectByName`, `EmployeeCopilot__IdentifyRecordByName`, `EmployeeCopilot__QueryRecords`, `EmployeeCopilot__QueryRecordsWithAggregate`, `Start_AEA_Account_Research_Report`.
- Topic `In_Depth_Web_Research` - Use this topic ONLY when the request requires external, exhaustive information gathering on research topics. This topic is for synthesizing complex, multi-faceted data points from the web into actionable research. Use this topic for all questions or requests. Functions: `EmployeeCopilot__WebSearch`.

## Flows
- `Agentforce_Account_Research_Report_Creator_Flow_AEA` (Agentforce Account Research Report Creator Flow AEA) status `Active` type `AutoLaunchedFlow` - This flow uses an Agentforce Employee Agent to create a detailed Account Research Report. After the research report is created it also creates a new record for safe keeping, writes summaries, and compared with previous reports. Finally a notification is sent to the user to alert them the Account Research Report is ready. Key actions: Account Intelligence Research Report Generator (generatePromptResponse: Account_Intelligence_Research_Report_Generator), Compare New Report with Old Report (generatePromptResponse: Account_Intelligence_Research_Report_Comparison), Count Sources (generatePromptResponse: Source_Counter), Send Notification (customNotificationAction: customNotificationAction), Summarize Account Overview (generatePromptResponse: Account_Intelligence_Research_Summarizer), Summarize Company Strategic Priorities from Research (generatePromptResponse: Account_Intelligence_Research_Summarizer).
- `Agentforce_Account_Research_Report_Creator_Maintain_Most_Recent_Flag` (Agentforce Account Research Report Creator Maintain Most Recent Flag) status `Active` type `AutoLaunchedFlow` - Keeps the most recent flag consistent when a new research report is created for an account.
- `Agentforce_Account_Research_Task` (Agentforce Account Research Task) status `Active` type `AutoLaunchedFlow` - This action takes an account ID and question/task about an Agentforce Account Research Report and answers/performs the task. Key actions: Answer Account Research Report Question or Task (generatePromptResponse: Agentforce_Account_Research_Task).

## Prompt Templates
- `Account_Intelligence_Research_Report_Comparison` - This prompt template compares new research reports to old research reports. (5 version(s); statuses: Published; inputs: `Old_Research_Report`, `New_Research_Report`)
- `Account_Intelligence_Research_Report_Generator` - This prompt template creates the final report for the Account Intelligence Research Report action. (10 version(s); statuses: Published; inputs: `Tech_Insights`, `Account`, `Positioning_and_Landscape`, `Strategic_Priorities`, `Company_Overview`)
- `Account_Intelligence_Research_Summarizer` - This prompt template summarizes the generated report. (7 version(s); statuses: Published, Draft; inputs: `Content_to_Summarize`)
- `Agentforce_Account_Research_Task` - This prompt template is used to answer questions about Account Research Reports or perform tasks related to getting information from the Account Research Reports or Accounts. (2 version(s); statuses: Published; inputs: `Question_or_Task`, `Account_Research_Report`, `Account`)
- `Source_Counter` - This prompt template adds up the total number of sources considered in the report generated. (3 version(s); statuses: Published; inputs: `Company_Overview`, `Positioning_and_Landscape`, `Strategic_Priorities`, `Tech_Insights`)

## Apex
Apex runtime classes: `AEA_Account_Research_Flow_Starter`, `AEA_Account_Research_Queueable`

Apex test classes: None

Invocable methods and key callouts:
- AEA_Account_Research_Flow_Starter: Start AEA Account Research Report - Enqueues the AEA Research Flow for the given Account Id.

## Data Model and UI
- `Account_Research_Report__c` (Account Research Report) with fields: `Account_Opportunities_Summary__c (Account Opportunities Summary, Html)`, `Account_Overview_Summary__c (Account Overview Summary, Html)`, `Account__c (Account, MasterDetail)`, `Comparison_to_Previous_Report__c (Comparison to Previous Report, Html)`, `Is_Most_Recent__c (Is Most Recent?, Checkbox)`, `Recent_News_Summary__c (Recent News Summary, Html)`, `Report_Summary__c (Report Summary, Html)`, `Report__c (Report, Html)`, `Run_Date_Time__c (Run Date/Time, DateTime)`, `Strategic_Positioning_Summary__c (Strategic Positioning Summary, Html)`, `Strategic_Priorities_Summary__c (Strategic Priorities Summary, Html)`, `Tech_Stack_and_Partnerships_Summary__c (Tech Stack and Partnerships Summary, Html)`
- Flexipages: `Enhanced_Account_Research_Report_Record_Page`
- Layouts: `Account_Research_Report__c-Account Research Report Layout`
- Notifications: `Account_Research_Complete_Notification`
- UI format sets: `Comparison_to_Previous_Report`

## Integrations and Credentials
- None retrieved.

No credential secret values were included in the retrieved metadata. Any API keys or named-principal secrets must be configured in the target org after deployment.
- The retrieved package contained a hardcoded Perplexity flow variable value; the Flow variable has been removed and credentials are now handled through External Credential setup.

## Prerequisites
- Salesforce org with Metadata API support and Salesforce CLI access.
- Agentforce and Prompt Builder features enabled for metadata that uses GenAiFunction, GenAiPlugin, or GenAiPromptTemplate.
- Permission to deploy Apex, Flow, Prompt Builder, Named Credential, External Credential, and custom object metadata as applicable.
- Access to any external API provider used by this package.

## Deployment
Authenticate to the target org, then validate first:

```bash
sf org login web --alias <target-org>
sf project deploy start --dry-run --manifest manifest/package.xml --target-org <target-org> --wait 30
```

Deploy after the dry run succeeds:

```bash
sf project deploy start --manifest manifest/package.xml --target-org <target-org> --wait 30
```

## Post-Deploy Setup
- Confirm Employee Agent / Agentforce Employee Actions are available in the target org.
- Verify EmployeeCopilot__WebSearch is available before activating the In_Depth_Web_Research topic.
- Activate or verify the included autolaunched flows after deployment.
- Grant users access to the Account Research Report object and any deployed agent actions.

## Testing and Validation
- Run a metadata dry run before deploying to a shared org.
- Run Apex tests listed above when present.
- Open each Flow in Flow Builder and confirm it is active or activate it after reviewing org-specific references.
- Open Prompt Builder templates and confirm the expected published version, model, and inputs.
- Test the Agentforce action with a low-risk sample prompt before giving it to end users.

## Package Provenance
- Source package: `Agentforce - Account Research w AEA`
- MetadataPackageId: `033Hn000000dj4rIAA`
- Retrieved from org alias: `pamigration`
- Package versions observed: `1.0.0 Beta (Winter 2026)`, `1.1.0 Beta (Winter 2026)`
- Repository name: `agentforce-account-research-w-aea`

## Notes for Maintainers
- Keep generated secrets, local org auth files, `.sf`, `.sfdx`, and deployment output out of source control.
- Treat prompt templates and Agentforce action descriptions as production behavior, not just documentation.
- For production hardening, prefer Named Credential and External Credential patterns over passing API keys directly through Flow variables.

## Hardening Update
Security and reliability improvements applied after migration:
- Removed the Perplexity API-key placeholder variable from the AEA research Flow.
- Added deployable runtime permission metadata for classes, flows, and report object access.
- The web-research topic instructions were narrowed to reduce overbroad routing.

## Known Limitations
- Employee Agent / EmployeeCopilot web-search availability must be confirmed in the target org.
- Flow fault handling should still be reviewed in Flow Builder before production use.

## Test Commands
Validate metadata and run relevant tests after authenticating to a target org:

```bash
sf project deploy start --dry-run --manifest manifest/package.xml --target-org <target-org> --wait 30
sf apex run test --class-names AEA_Account_Research_Hardening_Test --target-org <target-org> --result-format human --wait 10
```

## Troubleshooting
- If an Agentforce action cannot authenticate, confirm the named principal secret is configured in the target org and the running user has the included permission set.
- If a prompt action returns unsupported or unsafe content, review the prompt template safety rules and test with malicious retrieved content.
- If deployment fails on Agentforce metadata, deploy supporting objects, Apex, Flows, credentials, and prompt templates first, then wire/publish the target agent in Builder.
