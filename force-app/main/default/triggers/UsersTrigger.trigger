trigger UsersTrigger on User(after insert, after update){
	fflib_SObjectDomain.triggerHandler(tlz_Users.class);
}