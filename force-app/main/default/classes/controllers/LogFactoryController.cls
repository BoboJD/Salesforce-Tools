global with sharing class LogFactoryController{

	@AuraEnabled
	global static void commitError(String errorJSON){
		Error error = (Error)JSON.deserialize(errorJSON, Error.class);
		LogFactory.instance().logComponentError(error.url, error.formFactor, error.componentName, error.method, error.details).commitWork();
	}

	global class Error{
		global String url;
		global String formFactor;
		global String componentName;
		global String method;
		global String details;

		@TestVisible
		private Error(){}
	}
}