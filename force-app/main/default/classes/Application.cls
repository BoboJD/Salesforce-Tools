public inherited sharing class Application{

	public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType>{});

	public static final fflib_Application.ServiceFactory Service =
		new fflib_Application.ServiceFactory(
			new Map<Type, Type>{});

	public static final fflib_Application.SelectorFactory Selector =
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type>{
				PermissionSet.SObjectType => PermissionSetsSelector.class,
				PermissionSetAssignment.SObjectType => PermissionSetAssignmentsSelector.class});

	public static final fflib_Application.DomainFactory Domain =
		new fflib_Application.DomainFactory(
			Application.Selector,
				new Map<SObjectType, Type>{
					User.SObjectType => Users.Constructor.class});
}