global inherited sharing class WebserviceUtils{

	global static HttpResponse send(HttpRequest request){
		return send(request, false);
	}

	global static HttpResponse sendAndHandleError(HttpRequest request){
		return send(request, true);
	}

	@SuppressWarnings('PMD.AvoidDebugStatements')
	private static HttpResponse send(HttpRequest request, Boolean handleError){
		System.debug(LoggingLevel.FINEST, '> INPUT : '+request.getBody());
		HttpResponse response = new Http().send(request);
		LogFactory.instance().logWebserviceResponse(WebserviceUtils.class, request, response);
		System.debug(LoggingLevel.FINEST, '> OUTPUT : '+response.getBody());
		if(!handleError && apiHasError(response)){
			LogFactory.instance().logWebserviceError(WebserviceUtils.class, request, response);
			throw new WebserviceException(Label.AnErrorOccurredContactAnAdministrator);
		}
		return response;
	}

	global static Boolean apiHasError(HttpResponse response){
		return response.getStatusCode() != 200 && response.getStatusCode() != 201;
	}

	private class WebserviceException extends Exception{}
}