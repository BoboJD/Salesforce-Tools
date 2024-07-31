trigger ContentDocumentLinksTrigger on ContentDocumentLink(before insert, after insert){
	if(UserInfo.getUserType() != 'Guest'){
		fflib_SObjectDomain.triggerHandler(ContentDocumentLinks.class);
	}
}