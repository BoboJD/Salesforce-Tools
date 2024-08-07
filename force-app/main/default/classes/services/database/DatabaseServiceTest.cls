@IsTest
private class DatabaseServiceTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void executeBatchForDatabaseBatchableSObjectShouldReturnAsyncApexJobId(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Id asyncApexJobId = DatabaseService.executeBatch(new TestBatchJob());
			Assert.isNotNull(asyncApexJobId);
		}
	}

	@IsTest
	static void executeBatchForDatabaseBatchableSObjectAndNbOfIterationShouldReturnAsyncApexJobId(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Id asyncApexJobId = DatabaseService.executeBatch(new TestBatchJob(), 50);
			Assert.isNotNull(asyncApexJobId);
		}
	}
}