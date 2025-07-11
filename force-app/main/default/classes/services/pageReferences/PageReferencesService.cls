global inherited sharing class PageReferencesService{

	global static String getVisualforcePageUrl(String pageName, Map<String, String> valueByParameter){
		return service().getVisualforcePageUrl(pageName, valueByParameter);
	}

	global static String getUrl(String pageName, Map<String, String> valueByParameter){
		return service().getUrl(pageName, valueByParameter);
	}

	global static Blob getVisualforcePageContent(String pageName, Map<String, String> valueByParameter){
		return service().getVisualforcePageContent(pageName, valueByParameter);
	}

	global static Blob getPageContent(String pageName, Map<String, String> valueByParameter){
		return service().getPageContent(pageName, valueByParameter);
	}

	global static String getPageReferenceUrl(PageReference page, Map<String, String> valueByParameter){
		return service().getPageReferenceUrl(page, valueByParameter);
	}

	global static Blob getPageReferenceContent(PageReference page, Map<String, String> valueByParameter){
		return service().getPageReferenceContent(page, valueByParameter);
	}

	private static IPageReferencesService service(){
		return (IPageReferencesService)Application.Service.newInstance(IPageReferencesService.class);
	}
}