@IsTest
private class LogFactoryControllerTest{

	@TestSetup
	static void setup(){
		UserBuilder.newStandardUser().build();
	}

	@IsTest
	static void commitErrorShouldCreateOneLog(){
		User standard = TestUtils.selectStandardUser();
		System.runAs(standard){
			LogFactoryController.Error error = new LogFactoryController.Error();
			error.url = 'url';
			error.formFactor = 'Small';
			error.componentName = 'componentName';
			error.method = 'method';
			error.details = 'details';

			Test.startTest();
			LogFactoryController.commitError(JSON.serialize(error));
			Test.stopTest();

			Assert.logsCreated(1);
		}
	}
}