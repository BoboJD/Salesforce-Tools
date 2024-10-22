trigger UsersTrigger on User(after insert, after update){
	if(!tlz.FeatureManagementService.checkPermission('tlz__BypassProcessusUser'))
		fflib_SObjectDomain.triggerHandler(tlz_Users.class);
}