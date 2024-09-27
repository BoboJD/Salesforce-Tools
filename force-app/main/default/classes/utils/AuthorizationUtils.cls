@SuppressWarnings('PMD.CognitiveComplexity')
global with sharing class AuthorizationUtils{

	global static Boolean isAccessible(SObjectType sObjectType){
		return sObjectType != null && sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isAccessible();
	}

	global static Boolean isCreateable(SObjectType sObjectType){
		return sObjectType != null && sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isCreateable();
	}

	global static Boolean isUpdateable(SObjectType sObjectType){
		return sObjectType != null && sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isUpdateable();
	}

	global static Boolean isUpsertable(SObjectType sObjectType){
		return isCreateable(sObjectType) && isUpdateable(sObjectType);
	}

	global static Boolean isDeletable(SObjectType sObjectType){
		return sObjectType != null && sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isDeletable();
	}

	global static Boolean isUndeletable(SObjectType sObjectType){
		return sObjectType != null && sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isUndeletable();
	}

	global static void assertAccessible(SObjectType sObjectType){
		if(!isAccessible(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have access rights for ' + getSObjectTypeName(sObjectType));
	}

	global static void assertCreateable(SObjectType sObjectType){
		if(!isCreateable(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have create rights for ' + getSObjectTypeName(sObjectType));
	}

	global static void assertUpdateable(SObjectType sObjectType){
		if(!isUpdateable(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have update rights for ' + getSObjectTypeName(sObjectType));
	}

	global static void assertUpsertable(SObjectType sObjectType){
		if(!isUpsertable(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have create and update rights for ' + getSObjectTypeName(sObjectType));
	}

	global static void assertDeletable(SObjectType sObjectType){
		if(!isDeletable(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have delete rights for ' + getSObjectTypeName(sObjectType));
	}

	global static void assertUndeletable(SObjectType sObjectType){
		if(!isUndeletable(sObjectType))
			throw new AuthorizationException(UserInfo.getUserName() + ' does not have undelete rights for ' + getSObjectTypeName(sObjectType));
	}

	private static String getSObjectTypeName(SObjectType sObjectType){
		return sObjectType != null ? sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).getName() : '<unknown>';
	}

	private class AuthorizationException extends Exception{}
}