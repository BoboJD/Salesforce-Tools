trigger UsersTrigger on User(after insert, after update){
	if(!FeatureManagementService.checkPermission('tlz__BypassProcessusUser'))
		fflib_SObjectDomain.triggerHandler(tlz_Users.class);
}