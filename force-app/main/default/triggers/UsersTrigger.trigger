trigger UsersTrigger on User(after insert, after update){
	fflib_SObjectDomain.triggerHandler(Users.class);
}