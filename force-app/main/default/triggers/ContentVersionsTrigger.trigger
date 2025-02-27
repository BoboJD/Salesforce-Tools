trigger ContentVersionsTrigger on ContentVersion(before insert, after insert){
	if(!FeatureManagementService.checkPermission('tlz__BypassProcessusContentVersion'))
		fflib_SObjectDomain.triggerHandler(tlz_ContentVersions.class);
}