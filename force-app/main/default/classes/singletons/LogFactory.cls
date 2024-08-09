@SuppressWarnings('PMD.ExcessiveParameterList')
global without sharing class LogFactory{
	private static LogFactory instance;
	@TestVisible private List<Log__c> logs;

	private LogFactory(){
		logs = new List<Log__c>();
	}

	global static LogFactory instance(){
		if(instance == null) instance = new LogFactory();
		return instance;
	}

	global static void commitError(Type classApex, String methodName, List<Object> parameters, Exception e){
		instance().logError(classApex, methodName, parameters, e).commitWork();
	}

	global LogFactory logError(Type classApex, String methodName, List<Object> parameters, Exception e){
		String message = e != null ? e.getMessage() : null;
		if(errorCanBeLogged(message)){
			logs.add(new Log__c(
				RecordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_ERROR),
				Type__c = LogConstants.TYPE_APEX,
				File__c = classApex.getName(),
				Method__c = methodName,
				Parameters__c = formatParameters(parameters),
				Message__c = message,
				StackTrace__c = e != null ? e.getStackTraceString() : null
			));
		}
		return instance;
	}

	private Boolean errorCanBeLogged(String message){
		return String.isBlank(message)
			|| !StringUtils.containsAtLeastOneOfTheTerms(message, new List<String>{ExceptionConstants.UNABLE_TO_LOCK_ROW, ExceptionConstants.ENTITY_IS_DELETED});
	}

	global LogFactory logComponentError(String url, String formFactor, String componentName, String methodName, String details){
		if(errorCanBeLogged(details)){
			logs.add(new Log__c(
				RecordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_ERROR),
				Type__c = LogConstants.TYPE_LNG_CMP,
				File__c = componentName,
				Method__c = methodName,
				Parameters__c = url,
				FormFactor__c = formFactor,
				Message__c = details
			));
		}
		return instance;
	}

	global LogFactory logWebserviceError(Type classApex, HttpRequest request, HttpResponse response){
		String endpoint = request.getEndpoint();
		String parameters = request.getBody();
		if(String.isNotBlank(endpoint) && endpoint.contains('?')){
			endpoint = request.getEndpoint().split('\\?')[0];
			parameters = request.getEndpoint().split('\\?')[1];
		}
		logs.add(new Log__c(
			RecordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_ERROR),
			Type__c = LogConstants.TYPE_WEBSERVICE,
			File__c = classApex.getName(),
			Endpoint__c = endpoint,
			Parameters__c = parameters,
			StatusCode__c = response.getStatusCode(),
			Status__c = response.getStatus(),
			Message__c = response.getBody()
		));
		return instance;
	}

	global LogFactory logWebserviceResponse(Type classApex, HttpRequest request, HttpResponse response){
		String endpoint = request.getEndpoint();
		String parameters = request.getBody();
		if(String.isNotBlank(endpoint) && endpoint.contains('?')){
			endpoint = request.getEndpoint().split('\\?')[0];
			parameters = request.getEndpoint().split('\\?')[1];
		}
		logs.add(new Log__c(
			RecordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_INFO),
			Type__c = LogConstants.TYPE_WEBSERVICE,
			File__c = classApex.getName(),
			Endpoint__c = endpoint,
			Parameters__c = parameters,
			StatusCode__c = response.getStatusCode(),
			Message__c = response.getBody()?.left(131071)
		));
		return instance;
	}

	global LogFactory logWebserviceResponse(Type classApex, String endpoint, String parameters, String body){
		logs.add(new Log__c(
			RecordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_INFO),
			Type__c = LogConstants.TYPE_WEBSERVICE,
			File__c = classApex.getName(),
			Endpoint__c = endpoint,
			Parameters__c = parameters,
			Message__c = body?.left(131071)
		));
		return instance;
	}

	private String formatParameters(List<Object> parameters){
		String formattedParameters = '';
		if(parameters != null){
			for(Integer i = 0; i < parameters.size(); i++){
				Object parameter = parameters[i];
				formattedParameters += i + '=';
				if(doesntNeedToBeSerialized(parameter))
					formattedParameters += parameter;
				else
					formattedParameters += JSON.serialize(parameter);
				formattedParameters += '&';
			}
			formattedParameters = formattedParameters.removeEnd('&');
		}
		return formattedParameters;
	}

	private Boolean doesntNeedToBeSerialized(Object parameter){
		return parameter instanceof String || parameter instanceof Id;
	}

	global void commitWork(){
		if(AuthorizationUtil.isCreateable(Log__c.SObjectType))
			insert logs;
		logs.clear();
	}
}