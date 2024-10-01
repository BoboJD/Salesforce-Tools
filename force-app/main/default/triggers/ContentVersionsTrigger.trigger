trigger ContentVersionsTrigger on ContentVersion(before insert, after insert){
	fflib_SObjectDomain.triggerHandler(tlz_ContentVersions.class);
}