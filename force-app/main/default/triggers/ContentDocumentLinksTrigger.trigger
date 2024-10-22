trigger ContentDocumentLinksTrigger on ContentDocumentLink(before insert, after insert){
	if(!tlz.FeatureManagementService.checkPermission('BypassProcessusContentDocumentLink'))
		fflib_SObjectDomain.triggerHandler(tlz_ContentDocumentLinks.class);
}