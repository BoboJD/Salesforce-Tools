@IsTest
private class DatacloudServiceRestTest{

	static{
		RestContext.request = new RestRequest();
		RestContext.response = new RestResponse();
	}

	@IsTest
	static void findDuplicatesWithSameContactShouldReturnId(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IDatacloudService datacloudService = (IDatacloudService)mocks.mock(IDatacloudService.class);

		Contact contact = new Contact(Id = fflib_IDGenerator.generate(Schema.Contact.SObjectType));

		mocks.startStubbing();
		mocks.when(datacloudService.findDuplicates(contact)).thenReturn(new List<SObject>{contact});
		mocks.stopStubbing();

		Application.Service.setMock(IDatacloudService.class, datacloudService);

		RestContext.request.requestBody = Blob.valueOf(JSON.serialize(contact));

		Test.startTest();
		DatacloudServiceRest.findDuplicates();
		Test.stopTest();

		((IDatacloudService)mocks.verify(datacloudService)).findDuplicates(contact);

		Assert.equals(200, RestContext.response.statusCode);
		List<SObject> duplicates = (List<SObject>)JSON.deserialize(RestContext.response.responseBody.toString(), List<SObject>.class);
		Assert.equals(1, duplicates.size());
		Assert.equals(contact.Id, duplicates[0].Id);
	}

	@IsTest
	static void findDuplicatesWithWrongParameterShouldReturnError500(){
		RestContext.request.requestBody = Blob.valueOf(JSON.serialize(new List<String>{'toto'}));
		Test.startTest();
		DatacloudServiceRest.findDuplicates();
		Test.stopTest();

		Assert.equals(500, RestContext.response.statusCode);
	}
}