@IsTest
private class WebserviceUtilsTest{

	@IsTest
	static void sendShouldReturnAnHttpResponse(){
		Test.setMock(HttpCalloutMock.class, MockHttpResponseGenerator.initStringResponse(
			WebserviceConstants.APPLICATION_JSON, 200, '{}'
		));
		Test.startTest();
		HttpResponse response = WebserviceUtils.send(new HttpRequest());
		Test.stopTest();

		Assert.equals('{}', response.getBody());
	}

	@IsTest
	static void sendShouldThrowAnException(){
		Test.setMock(HttpCalloutMock.class, MockHttpResponseGenerator.initStringResponse(
			WebserviceConstants.APPLICATION_JSON, 500, ''
		));
		Test.startTest();
		String errorMessage;
		try{
			WebserviceUtils.send(new HttpRequest());
		}catch (Exception e){
			errorMessage = e.getMessage();
		}
		Test.stopTest();

		Assert.equals(Label.AnErrorOccurredContactAnAdministrator, errorMessage);
		Assert.equals(2, LogFactory.instance().logs.size());
	}

	@IsTest
	static void sendAndHandleErrorShouldNotThrowAnException(){
		Test.setMock(HttpCalloutMock.class, MockHttpResponseGenerator.initStringResponse(
			WebserviceConstants.APPLICATION_JSON, 500, '{}'
		));
		Test.startTest();
		HttpResponse response = WebserviceUtils.sendAndHandleError(new HttpRequest());
		Test.stopTest();

		Assert.equals('{}', response.getBody());
	}
}