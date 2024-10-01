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
				IEmailTemplatesService.class => EmailTemplatesServiceImpl.class,
				IFeatureManagementService.class => FeatureManagementServiceImpl.class,
				IMessagingService.class => MessagingServiceImpl.class,
				IOrganizationsService.class => OrganizationsServiceImpl.class});

	global static final fflib_Application.SelectorFactory Selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type>{
				ContentDocument.SObjectType => ContentDocumentsSelector.class,
				ContentDocumentLink.SObjectType => ContentDocumentLinksSelector.class,
				ContentVersion.SObjectType => ContentVersionsSelector.class,
				CustomNotificationType.SObjectType => CustomNotificationTypesSelector.class,
				Organization.SObjectType => OrganizationsSelector.class,
				PermissionSet.SObjectType => PermissionSetsSelector.class,
				PermissionSetAssignment.SObjectType => PermissionSetAssignmentsSelector.class,
				User.SObjectType => UsersSelector.class,
				UserRecordAccess.SObjectType => UserRecordAccessesSelector.class});

	global static final fflib_Application.DomainFactory Domain =
		new fflib_Application.DomainFactory(
			Application.Selector,
				new Map<SObjectType, Type>{
					ContentDocumentLink.SObjectType => tlz_ContentDocumentLinks.Constructor.class,
					ContentVersion.SObjectType => tlz_ContentVersions.Constructor.class,
					User.SObjectType => tlz_Users.Constructor.class});
}