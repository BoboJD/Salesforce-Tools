@IsTest
private class DatabaseServiceTest{

	@IsTest
	static void executeBatchForDatabaseBatchableSObjectShouldReturnAsyncApexJobId(){
		Id asyncApexJobId = DatabaseService.executeBatch(new TestBatchJob());
		Assert.isNotNull(asyncApexJobId);
	}

	@IsTest
	static void executeBatchForDatabaseBatchableSObjectAndNbOfIterationShouldReturnAsyncApexJobId(){
		Id asyncApexJobId = DatabaseService.executeBatch(new TestBatchJob(), 50);
		Assert.isNotNull(asyncApexJobId);
	}
}