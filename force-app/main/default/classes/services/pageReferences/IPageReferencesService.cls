global interface IPageReferencesService{
	String getVisualforcePageUrl(String pageName, Map<String, String> valueByParameter);
	String getUrl(String pageName, Map<String, String> valueByParameter);
	Blob getVisualforcePageContent(String pageName, Map<String, String> valueByParameter);
	Blob getPageContent(String pageName, Map<String, String> valueByParameter);
	String getPageReferenceUrl(PageReference page, Map<String, String> valueByParameter);
	Blob getPageReferenceContent(PageReference page, Map<String, String> valueByParameter);
}