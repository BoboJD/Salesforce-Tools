@IsTest
global with sharing class Assert{

	global static void isTrue(Object logicalExpression){
		isNotNull(logicalExpression);
		System.Assert.isTrue((Boolean)logicalExpression, 'Boolean is "false" instead of "true"');
	}

	global static void isFalse(Object logicalExpression){
		isNotNull(logicalExpression);
		System.Assert.isFalse((Boolean)logicalExpression, 'Boolean is "true" instead of "false"');
	}

	global static void isBlank(String message){
		System.Assert.isTrue(String.isBlank(message), 'String is not blank : ' + message);
	}

	global static void isNotBlank(String message){
		System.Assert.isTrue(String.isNotBlank(message), 'String is blank');
	}

	global static void equals(Object expected, Object actual){
		System.Assert.areEqual(expected, actual);
	}

	global static void notEquals(Object expected, Object actual){
		System.Assert.areNotEqual(expected, actual);
	}

	global static void isNull(Object obj){
		System.Assert.isNull(obj, 'Argument not "null"');
	}

	global static void isNotNull(Object obj){
		System.Assert.isNotNull(obj, 'Argument is "null"');
	}

	global static void isEmpty(List<Object> objects){
		System.Assert.isTrue(objects?.isEmpty(), 'List is not empty');
	}

	global static void isNotEmpty(List<Object> objects){
		System.Assert.isFalse(objects?.isEmpty(), 'List is empty');
	}

	global static void isEmpty(Set<Object> objects){
		System.Assert.isTrue(objects?.isEmpty(), 'Set is not empty');
	}

	global static void isNotEmpty(Set<Object> objects){
		System.Assert.isFalse(objects?.isEmpty(), 'Set is empty');
	}

	global static void isNow(Datetime actualDate){
		equals(DateUtils.now(), actualDate);
	}

	global static void success(Map<String, Object> result){
		System.Assert.areEqual(Constants.SUCCESS, result.get(Constants.STATUS), 'Error occured : '+(String)result.get(Constants.MESSAGE));
	}

	global static void error(Map<String, Object> result){
		equals(Constants.ERROR, result.get(Constants.STATUS));
	}

	global static void errorWithMessage(Map<String, Object> result){
		errorWithMessage(result, null);
	}

	global static void errorWithMessage(Map<String, Object> result, String expectedMessage){
		error(result);
		String errorMessage = (String)result.get(Constants.MESSAGE);
		System.Assert.isTrue(String.isNotBlank(errorMessage), 'No error message thrown.');
		if(String.isNotBlank(expectedMessage))
			System.Assert.isTrue(errorMessage.containsIgnoreCase(expectedMessage),
				'Error "'+errorMessage+'" does not contains message : '+expectedMessage);
	}

	global static void errorWithLog(Map<String, Object> result){
		errorWithLog(result, null);
	}

	global static void errorWithLog(Map<String, Object> result, String message){
		errorWithMessage(result, message);
		List<Log__c> logs = [SELECT Id FROM Log__c];
		System.Assert.areEqual(1, logs.size(), 'No log created.');
	}

	global static void logsCreated(Integer numberOfLogs){
		List<Log__c> logs = [SELECT Id FROM Log__c];
		if(numberOfLogs > 0)
			System.Assert.isFalse(logs?.isEmpty(), 'No log created.');
		System.Assert.areEqual(numberOfLogs, logs.size(), 'Expected '+numberOfLogs+' log(s), Actual : '+logs.size()+'+ logs(s)');
	}

	global static void messageContains(String message, String searchedTerm){
		System.Assert.isNotNull(message, 'Message is empty.');
		System.Assert.isNotNull(searchedTerm, 'Given text to search is empty.');
		Boolean searchedTermFound = message.contains(searchedTerm);
		System.Assert.isTrue(searchedTermFound, 'Text not found in the message : '+message);
	}

	global static void listContains(List<Object> listToSearch, Object searchedObj){
		System.Assert.isNotNull(listToSearch, 'List to search is null.');
		System.Assert.isNotNull(searchedObj, 'Given object to search is null.');
		Boolean objectFound = false;
		for(Object listElement : listToSearch){
			if(listElement == searchedObj)
				objectFound = true;
		}
		System.Assert.isTrue(objectFound, 'Value in list not found');
	}

	global static void atLeastOneSObjectEquals(List<SObject> sObjects, SObjectField sObjectField, Object fieldValue){
		System.Assert.isNotNull(sObjects, 'List of SObjects is null.');
		System.Assert.isNotNull(sObjectField, 'The SObjectField parameter is null.');
		Boolean fieldValueFound = false;
		for(SObject sObj : sObjects){
			if(sObj.get(sObjectField) == fieldValue)
				fieldValueFound = true;
		}
		System.Assert.isTrue(fieldValueFound, 'Value in list not found for sObjectField '+SObjectFieldUtils.getFieldApiName(sObjectField));
	}
}