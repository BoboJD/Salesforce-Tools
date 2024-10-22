trigger ContentVersionsTrigger on ContentVersion(before insert, after insert){
	if(!tlz.FeatureManagementService.checkPermission('BypassProcessusContentVersion'))
		fflib_SObjectDomain.triggerHandler(tlz_ContentVersions.class);
}