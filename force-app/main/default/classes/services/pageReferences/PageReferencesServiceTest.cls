@IsTest
private class PageReferencesServiceTest{

	@IsTest
	static void getVisualforcePageUrlShouldReturnVisuaforceUrl(){
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		String visualforceUrl = PageReferencesService.getVisualforcePageUrl('test', new Map<String, String>{'id' => accountId});
		Assert.equals('/apex/test?id='+accountId, visualforceUrl);
	}

	@IsTest
	static void getUrlShouldReturnBasicUrl(){
		String url = PageReferencesService.getUrl('https://www.google.fr', new Map<String, String>{'a' => '1', 'b' => '2'});
		Assert.equals('https://www.google.fr?a=1&b=2', url);
	}

	@IsTest
	static void getUrlWithoutUrlShouldThrowError(){
		String errorMessage;
		try{
			PageReferencesService.getUrl(null, null);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Assert.equals(Label.UnknownPageReference, errorMessage);
	}

	@IsTest
	static void getVisualforcePageContentShouldReturnBlob(){
		Blob content = PageReferencesService.getVisualforcePageContent('test', null);
		Assert.equals(Blob.valueOf('Test'), content);
	}

	@IsTest
	static void getPageContentShouldReturnBlob(){
		Blob content = PageReferencesService.getPageContent('test', null);
		Assert.equals(Blob.valueOf('Test'), content);
	}

	@IsTest
	static void getPageContentWithoutUrlShouldThrowError(){
		String errorMessage;
		try{
			PageReferencesService.getPageContent(null, null);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Assert.equals(Label.UnknownPageReference, errorMessage);
	}

	@IsTest
	static void getPageReferenceUrlShouldReturnPageReferenceUrl(){
		Id opportunityId = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType);
		PageReference pageReference = Page.ReportToExcel;
		String visualforceUrl = PageReferencesService.getPageReferenceUrl(pageReference, new Map<String, String>{'id' => opportunityId});
		Assert.equals('/apex/tlz__reporttoexcel?id='+opportunityId, visualforceUrl);
	}

	@IsTest
	static void getPageReferenceUrlWithNullParametersShouldThrowError(){
		String errorMessage;
		try{
			PageReferencesService.getPageReferenceUrl(null, null);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Assert.equals(Label.UnknownPageReference, errorMessage);
	}

	@IsTest
	static void getPageReferenceContentWithPageReferenceShouldReturnBlob(){
		Id opportunityId = fflib_IDGenerator.generate(Schema.Opportunity.SObjectType);
		PageReference pageReference = Page.ReportToExcel;
		Blob content = PageReferencesService.getPageReferenceContent(pageReference, new Map<String, String>{'id' => opportunityId});
		Assert.equals(opportunityId, pageReference.getParameters().get('id'));
		Assert.equals(Blob.valueOf('Test'), content);
	}

	@IsTest
	static void getPageReferenceContentWithNullParametersShouldThrowError(){
		String errorMessage;
		try{
			PageReferencesService.getPageReferenceContent(null, null);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Assert.equals(Label.UnknownPageReference, errorMessage);
	}
}