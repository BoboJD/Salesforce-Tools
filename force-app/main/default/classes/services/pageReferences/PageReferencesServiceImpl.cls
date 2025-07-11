global inherited sharing class PageReferencesServiceImpl implements IPageReferencesService{

	global String getVisualforcePageUrl(String pageName, Map<String, String> valueByParameter){
		return getUrl(pageName, valueByParameter, true);
	}

	global String getUrl(String pageName, Map<String, String> valueByParameter){
		return getUrl(pageName, valueByParameter, false);
	}

	private String getUrl(String pageName, Map<String, String> valueByParameter, Boolean isVisualforce){
		if(String.isBlank(pageName))
			throw new PageReferenceException(Label.UnknownPageReference);
		String url = (isVisualforce ? '/apex/' : '') + pageName;
		if(valueByParameter != null && !valueByParameter.isEmpty()){
			url += '?';
			for(String parameter : valueByParameter.keySet())
				url += parameter + '=' + valueByParameter.get(parameter) + '&';
			url = url.removeEnd('&');
		}
		return url;
	}

	global Blob getVisualforcePageContent(String pageName, Map<String, String> valueByParameter){
		return getPageContent(pageName, valueByParameter, true);
	}

	global Blob getPageContent(String pageName, Map<String, String> valueByParameter){
		return getPageContent(pageName, valueByParameter, false);
	}

	private Blob getPageContent(String pageName, Map<String, String> valueByParameter, Boolean isVisualforce){
		if(String.isBlank(pageName))
			throw new PageReferenceException(Label.UnknownPageReference);
		String url = getUrl(pageName, valueByParameter, isVisualforce);
		PageReference template = new PageReference(url);
		return Test.isRunningTest() ? Blob.valueOf('Test') : template.getContent();
	}

	global String getPageReferenceUrl(PageReference page, Map<String, String> valueByParameter){
		putParametersToPageReference(page, valueByParameter);
		return page.getUrl();
	}

	private void putParametersToPageReference(PageReference page, Map<String, String> valueByParameter){
		if(page == null)
			throw new PageReferenceException(Label.UnknownPageReference);
		if(valueByParameter != null && !valueByParameter.isEmpty()){
			for(String parameter : valueByParameter.keySet())
				page.getParameters().put(parameter, valueByParameter.get(parameter));
		}
	}

	global Blob getPageReferenceContent(PageReference page, Map<String, String> valueByParameter){
		putParametersToPageReference(page, valueByParameter);
		return Test.isRunningTest() ? Blob.valueOf('Test') : page.getContent();
	}

	private class PageReferenceException extends Exception{}
}