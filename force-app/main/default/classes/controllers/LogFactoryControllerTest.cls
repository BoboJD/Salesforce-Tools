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

			List<Log__c> logs = [SELECT Id FROM Log__c];
			Assert.equals(1, logs.size());
		}
	}
}