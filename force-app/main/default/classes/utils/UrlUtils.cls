global inherited sharing class UrlUtils{

	global static String getSoapUrl(){
		return URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/u/' + Constants.LATEST_SALESFORCE_VERSION + '/' + UserInfo.getOrganizationId();
	}

	global static String replaceParameterValue(String fullUrl, String paramName, String newValue){
		if(String.isblank(fullUrl) || String.isBlank(paramName)) return fullUrl;
		List<String> urlParts = fullUrl.split('\\?');
		String baseUrl = urlParts[0];
		String queryString = urlParts.size() > 1 ? urlParts[1] : urlParts[0];
		List<String> parameters = String.isNotBlank(queryString) ? queryString.split('&') : new List<String>();
		Boolean paramFound = false;
		for(Integer i = 0; i < parameters.size(); i++){
			if(parameters[i].startsWith(paramName + '=')){
				parameters[i] = paramName + '=' + newValue;
				paramFound = true;
				break;
			}
		}
		if(!paramFound) parameters.add(paramName + '=' + newValue);
		return (urlParts.size() > 1 ? baseUrl + '?' : '') + (parameters.isEmpty() ? '' : String.join(parameters, '&'));
	}
}