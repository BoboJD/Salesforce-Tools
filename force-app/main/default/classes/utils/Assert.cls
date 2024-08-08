@IsTest
public with sharing class Assert{

	public static void isTrue(Object logicalExpression){
		isNotNull(logicalExpression);
		System.Assert.isTrue((Boolean)logicalExpression, 'Boolean is "false" instead of "true"');
	}

	public static void isFalse(Object logicalExpression){
		isNotNull(logicalExpression);
		System.Assert.isFalse((Boolean)logicalExpression, 'Boolean is "true" instead of "false"');
	}

	public static void isBlank(String message){
		System.Assert.isTrue(String.isBlank(message), 'String is not blank : ' + message);
	}

	public static void isNotBlank(String message){
		System.Assert.isTrue(String.isNotBlank(message), 'String is blank');
	}

	public static void equals(Object expected, Object actual){
		System.Assert.areEqual(expected, actual);
	}

	public static void notEquals(Object expected, Object actual){
		System.Assert.areNotEqual(expected, actual);
	}

	public static void isNull(Object obj){
		System.Assert.isNull(obj, 'Argument not "null"');
	}

	public static void isNotNull(Object obj){
		System.Assert.isNotNull(obj, 'Argument is "null"');
	}

	public static void success(Map<String, Object> result){
		System.Assert.areEqual(Constants.SUCCESS, result.get(Constants.STATUS), 'Error occured : '+(String)result.get(Constants.MESSAGE));
	}

	public static void error(Map<String, Object> result){
		equals(Constants.ERROR, result.get(Constants.STATUS));
	}

	public static void errorWithMessage(Map<String, Object> result){
		errorWithMessage(result, null);
	}

	public static void errorWithMessage(Map<String, Object> result, String expectedMessage){
		error(result);
		String errorMessage = (String)result.get(Constants.MESSAGE);
		System.Assert.isTrue(String.isNotBlank(errorMessage), 'No error message thrown.');
		if(String.isNotBlank(expectedMessage))
			System.Assert.isTrue(errorMessage.containsIgnoreCase(expectedMessage),
				'Error "'+errorMessage+'" does not contains message : '+expectedMessage);
	}

	public static void errorWithLog(Map<String, Object> result){
		errorWithLog(result, null);
	}

	public static void errorWithLog(Map<String, Object> result, String message){
		errorWithMessage(result, message);
		List<Log__c> logs = [SELECT Id FROM Log__c];
		System.Assert.areEqual(1, logs.size(), 'No log created.');
	}

	public static void messageContains(String message, String searchedTerm){
		System.Assert.isNotNull(message, 'Message is empty.');
		System.Assert.isNotNull(searchedTerm, 'Given text to search is empty.');
		Boolean searchedTermFound = message.contains(searchedTerm);
		System.Assert.isTrue(searchedTermFound, 'Text not found in the message : '+message);
	}

	public static void listContains(List<Object> listToSearch, Object searchedObj){
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