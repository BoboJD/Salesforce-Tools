public with sharing class LogFactoryController{

	@AuraEnabled
	public static void commitError(String errorJSON){
		Error error = (Error)JSON.deserialize(errorJSON, Error.class);
		LogFactory.instance().logComponentError(error.url, error.formFactor, error.componentName, error.method, error.details).commitWork();
	}

	public class Error{
		public String url;
		public String formFactor;
		public String componentName;
		public String method;
		public String details;

		@TestVisible
		private Error(){}
	}
}