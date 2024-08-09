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
}