@IsTest
private class FileRecordIdUpdateSchedulerTest{

	@IsTest
	static void runSchedulerShouldPlanifyCodeExecution(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IDatabaseService databaseServiceMock = new Mocks.DatabaseService(mocks);

		Application.Service.setMock(IDatabaseService.class, databaseServiceMock);

		Test.startTest();
		Id cronTriggerId = System.schedule(
			'TEST Verification of files relationship',
			'0 0 2 * * ?',
			FileRecordIdUpdateScheduler.newInstance());
		Test.stopTest();

		((IDatabaseService)mocks.verify(databaseServiceMock)).executeBatch((FileRecordIdUpdateJob)fflib_Match.anyObject());

		CronTrigger cronTrigger = [SELECT CronExpression FROM CronTrigger WHERE Id = :cronTriggerId];
		Assert.equals('0 0 2 * * ?', cronTrigger.CronExpression);
	}
}