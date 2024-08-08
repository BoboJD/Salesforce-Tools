#!/bin/bash

# Copy this file in your project in a folder "scripts/" at the root
# then uncomments things you want to use for the scripts, you can add elements to array

# General settings for scripts
## Salesforce xml namespace
xml_namespace="http://soap.sforce.com/2006/04/metadata"

## Project settings
project_directory="force-app/main/default/"
github_repository_url="https://github.com/BoboJD/Salesforce-Tools"
# archive_logs_folder="\\\\NAS\\Archive\\Log__c"

## Org settings
PRODUCTION_ORG_ID="00D24000000q9b8EAA"
devhub_name="salesforce-tools"
# territories_used="true"
# experience_cloud_used="true"
# org_shape_enable="true"

## ViewAllRecords permissionsets
# viewallrecords_permissionsets=("ViewAllFiles")

# Feature for scripts
## Auto update settings
# check_windows_git_update="true"
# check_global_npm_packages_update="true"
# check_npm_packages_update="true"

# Settings for scratch org creation methods
## Appexchange
# declare -A appexchange_id_by_name=(
# 	["Conga Composer"]="04t5w000005ujfZAAQ"
# )
# appexchange_installation_order=("Conga Composer")

## Dashboards to deploy
# dashboards=(
# 	"MyFolder/MyDashboardIdXCxAtxGYiMIeSHXlPkmFcBzPWUTdgR"
# )

## Picklists with controlling field needs to be removed, listed as 'SObjectApiName.PicklistApiName'
# controlling_picklists_with_deploy_issue=(
# 	"Opportunity.SObjectFieldApiName__c"
# )

## Standard metadata to rename, concatenation listed as 'MetadataType:OldValue:NewValue'
# standard_metadata_to_rename=(
# 	"RecordType:Account.Business_Account:Account.B2B"
# 	"PicklistValue:Account.Type.Partner:Account.Type.Partenaire"
# )

# Settings for 'retrievedManualChanges'
## Layout permissions to remove in profiles
# unused_standard_layouts=(
# 	"AccountBrand"
# 	"AccountTeamMember"
# 	"Address"
# 	"Asset"
# 	"AssetRelationship"
# 	"AssociatedLocation"
# 	"AuditTrailFileExport"
# 	"AuthorizationForm"
# 	"AuthorizationFormConsent"
# 	"AuthorizationFormDataUse"
# 	"AuthorizationFormText"
# 	"BusinessBrand"
# 	"CalcMatrixColumnRange"
# 	"CalcProcStepRelationship"
# 	"CalculationMatrix"
# 	"CalculationMatrixColumn"
# 	"CalculationMatrixRow"
# 	"CalculationMatrixVersion"
# 	"CalculationProcedure"
# 	"CalculationProcedureStep"
# 	"CalculationProcedureVariable"
# 	"CalculationProcedureVersion"
# 	"CampaignInfluenceModel"
# 	"CampaignMemberStatus"
# 	"CaseInteraction"
# 	"CaseMilestone"
# 	"ChannelProgram"
# 	"ChannelProgramLevel"
# 	"CollaborationGroup"
# 	"CommunityMemberLayout"
# 	"ContactPointAddress"
# 	"ContactPointEmail"
# 	"ContactPointPhone"
# 	"ContactPointTypeConsent"
# 	"ContentAsset"
# 	"ContentVersion"
# 	"Contract"
# 	"ContractLineItem"
# 	"CspTrustedSite"
# 	"Customer"
# 	"DataUseLegalBasis"
# 	"DataUsePurpose"
# 	"DelegatedAccount"
# 	"DuplicateRecordItem"
# 	"DuplicateRecordSet"
# 	"EmailMessage"
# 	"EmpUserProvisionProcessErr"
# 	"EmpUserProvisioningProcess"
# 	"Employee"
# 	"EnhancedLetterhead"
# 	"EngagementInteraction"
# 	"EngagementTopic"
# 	"Entitlement"
# 	"EntityMilestone"
# 	"ExpressionSet"
# 	"ExpressionSetVersion"
# 	"FeedItem"
# 	"FlowInterview"
# 	"FlowOrchestrationWorkItem"
# 	"Global"
# 	"Knowledge__kav"
# 	"Idea"
# 	"Individual"
# 	"InternalOrganizationUnit"
# 	"ListEmail"
# 	"Location"
# 	"LocationTrustMeasure"
# 	"Macro"
# 	"ObjectTerritory2AssignmentRule"
# 	"OpportunityTeamMember"
# 	"Order"
# 	"OrderItem"
# 	"ProcessException"
# 	"ProfileSkill"
# 	"ProfileSkillEndorsement"
# 	"ProfileSkillUser"
# 	"QuickText"
# 	"SalesforceContract"
# 	"Scorecard"
# 	"ScorecardAssociation"
# 	"ScorecardMetric"
# 	"Seller"
# 	"ServiceContract"
# 	"SocialPersona"
# 	"Solution"
# 	"Territory2"
# 	"Territory2Type"
# 	"Territory2Model"
# 	"Territory2ObjSharingConfig"
# 	"UserAppMenuItem"
# 	"UserProvAccount"
# 	"UserProvisioningLog"
# 	"UserProvisioningRequest"
# 	"UserTerritory2Association"
# 	"WorkAccess"
# 	"WorkBadge"
# 	"WorkBadgeDefinition"
# 	"WorkPlan"
# 	"WorkPlanTemplate"
# 	"WorkPlanTemplateEntry"
# 	"WorkStep"
# 	"WorkStepTemplate"
# 	"WorkThanks"
# )

## System permissions to remove in profiles
# user_permissions_to_delete=(
# 	"TraceXdsQueries"
# 	"AllowObjectDetectionTraining"
# )

## Untracked permissions to remove in profiles
# unnecessary_permissions_to_delete=(
# 	"customMetadataTypeAccesses"
# 	"fieldPermissions"
# 	"recordTypeVisibilities"
# )