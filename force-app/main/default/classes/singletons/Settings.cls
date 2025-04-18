global with sharing class Settings{
	private static Settings instance;
	private Setting__c record;

	private Settings(Boolean bypassException){
		record = retrieveConfigurationFromName(bypassException);
	}

	private Setting__c retrieveConfigurationFromName(Boolean bypassException){
		List<Setting__c> records = Database.query(constructSoqlQuery());
		if(records.isEmpty() && !bypassException)
			throw new SettingsException(Label.DefaultSettingNotCreated);
		return records.isEmpty() ? null : records[0];
	}

	private String constructSoqlQuery(){
		List<String> fields = new List<String>();
		for(SObjectField sObjectField : Setting__c.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap().values())
			fields.add(sObjectField.getDescribe(FieldDescribeOptions.DEFAULT).getName());
		return 'SELECT '+String.join(fields, ', ')
			+ ' FROM tlz__Setting__c'
			+ ' WHERE Name = \'Default\'';
	}

	global static Object get(SObjectField sObjectField){
		return get(Test.isRunningTest(), sObjectField);
	}

	global static Object get(String sObjectFieldName){
		return get(Test.isRunningTest(), sObjectFieldName);
	}

	global static List<String> getValues(SObjectField sObjectField){
		String values = (String)get(sObjectField);
		return values?.split(';') ?? new List<String>();
	}

	@TestVisible
	private static Object get(Boolean bypassException, SObjectField sObjectField){
		return getInstance(bypassException).record?.get(sObjectField);
	}

	@TestVisible
	private static Object get(Boolean bypassException, String sObjectFieldName){
		return getInstance(bypassException).record?.get(sObjectFieldName);
	}

	private static Settings getInstance(Boolean bypassException){
		if(instance == null)
			instance = new Settings(bypassException);
		return instance;
	}

	private class SettingsException extends Exception{}
}