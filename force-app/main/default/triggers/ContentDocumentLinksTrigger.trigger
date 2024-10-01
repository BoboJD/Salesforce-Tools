trigger ContentDocumentLinksTrigger on ContentDocumentLink(before insert, after insert){
	fflib_SObjectDomain.triggerHandler(tlz_ContentDocumentLinks.class);
}