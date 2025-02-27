trigger ContentDocumentLinksTrigger on ContentDocumentLink(before insert, after insert){
	if(!FeatureManagementService.checkPermission('tlz__BypassProcessusContentDocumentLink') && UserInfo.getUserType() != 'Guest')
		fflib_SObjectDomain.triggerHandler(tlz_ContentDocumentLinks.class);
}