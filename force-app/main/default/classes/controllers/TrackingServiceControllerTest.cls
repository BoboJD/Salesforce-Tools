@IsTest
private class TrackingServiceControllerTest{

	@IsTest
	static void commitTrackingShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		String functionality = 'test';

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		Map<String, Object> result = TrackingServiceController.commitTracking(functionality);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerNew(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.Tracking__c.Functionality__c => functionality}));
		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).commitWork();

		Assert.success(result);
	}

	@IsTest
	static void commitTrackingShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = TrackingServiceController.commitTracking(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}
}