@IsTest
private class RecordHistoryControllerTest{

	@IsTest
	static void getHistoryShouldReturnOneRecord(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();
			SObjectHistory__c history = new SObjectHistory__c(RecordId__c = account.Id);
			insert history;

			Test.startTest();
			List<SObjectHistory__c> records = RecordHistoryController.getHistory(account.Id);
			Test.stopTest();

			Assert.equals(1, records.size());
		}
	}
}