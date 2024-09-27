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

	@IsTest
	static void iterateForDatabaseIteratorAndNbOfIterationShouldReturnAsyncApexJobId(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			new CustomIterator(); // coverage for CustomIterator
			TestIterator iterator = new TestIterator(new List<TestIterator.CustomLoop>{
				new TestIterator.CustomLoop(),
				new TestIterator.CustomLoop()
			});

			Test.startTest();
			Id asyncApexJobId = DatabaseService.iterate(iterator, 100);
			Test.stopTest();

			Assert.isNotNull(asyncApexJobId);
			Assert.equals(2, TestIterator.numberOfLoop);
		}
	}
}