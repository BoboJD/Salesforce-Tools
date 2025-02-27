global inherited sharing class Application{

	global static final fflib_Application.UnitOfWorkFactory UnitOfWork =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType>{});

	global static final fflib_Application.ServiceFactory Service =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type>{
				IConnectApiService.class => ConnectApiServiceImpl.class,
				ICustomNotificationsService.class => CustomNotificationsServiceImpl.class,
				IDatabaseService.class => DatabaseServiceImpl.class,
				IDatacloudService.class => DatacloudServiceImpl.class,
				IEmailService.class => EmailServiceImpl.class,
				IEmailTemplatesService.class => EmailTemplatesServiceImpl.class,
				IFeatureManagementService.class => FeatureManagementServiceImpl.class,
				IMessagingService.class => MessagingServiceImpl.class,
				IOrganizationsService.class => OrganizationsServiceImpl.class});

	global static final fflib_Application.SelectorFactory Selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type>{
				ContentDocument.SObjectType => tlz_ContentDocumentsSelector.class,
				ContentDocumentLink.SObjectType => tlz_ContentDocumentLinksSelector.class,
				ContentVersion.SObjectType => tlz_ContentVersionsSelector.class,
				CustomNotificationType.SObjectType => tlz_CustomNotificationTypesSelector.class,
				Organization.SObjectType => tlz_OrganizationsSelector.class,
				OrgWideEmailAddress.SObjectType => tlz_OrgWideEmailAddressesSelector.class,
				PermissionSet.SObjectType => tlz_PermissionSetsSelector.class,
				PermissionSetAssignment.SObjectType => tlz_PermissionSetAssignmentsSelector.class,
				User.SObjectType => tlz_UsersSelector.class,
				UserRecordAccess.SObjectType => tlz_UserRecordAccessesSelector.class});

	global static final fflib_Application.DomainFactory Domain =
		new fflib_Application.DomainFactory(
			Application.Selector,
				new Map<SObjectType, Type>{
					ContentDocumentLink.SObjectType => tlz_ContentDocumentLinks.Constructor.class,
					ContentVersion.SObjectType => tlz_ContentVersions.Constructor.class,
					User.SObjectType => tlz_Users.Constructor.class});
}