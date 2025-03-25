@IsTest
private class RefreshEventPublisherControllerTest{

	@IsTest
	static void testPublishRefreshEvent(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Test.startTest();
			RefreshEventPublisherController.publishRefreshEvent();
			Test.stopTest();
		}
	}
}