trigger ContentVersionsTrigger on ContentVersion(before insert, after insert){
	fflib_SObjectDomain.triggerHandler(ContentVersions.class);
}