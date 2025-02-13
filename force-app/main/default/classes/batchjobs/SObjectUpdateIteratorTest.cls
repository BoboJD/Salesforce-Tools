@IsTest
private class SObjectUpdateIteratorTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void runIteratorShouldUpdateRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			fflib_ApexMocks mocks = new fflib_ApexMocks();
			ICustomNotificationsService customNotificationsServiceMock = new Mocks.CustomNotificationsService(mocks);

			Account account = TestUtils.selectAccount();
			account.Name = 'Tototo';

			Application.Service.setMock(ICustomNotificationsService.class, customNotificationsServiceMock);

			Test.startTest();
			Database.executeBatch(SObjectUpdateIterator.newInstance(new List<SObject>{ account }), 1);
			Test.stopTest();

			((ICustomNotificationsService)mocks.verify(customNotificationsServiceMock)).notifyUser(UserInfo.getUserId(), Label.SObjectUpdateIteratorTitle,
				String.format(Label.SObjectUpdateIteratorMessage, new List<Object>{ 1, 0 }));

			Account accountAfter = [SELECT Name FROM Account WHERE Id = :account.Id];
			Assert.equals('Tototo', accountAfter.Name);
		}
	}
}