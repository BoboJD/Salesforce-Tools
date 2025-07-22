@IsTest
private class SObjectDmlIteratorTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void runIteratorForInsertShouldInsertRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			fflib_ApexMocks mocks = new fflib_ApexMocks();
			ICustomNotificationsService customNotificationsServiceMock = new Mocks.CustomNotificationsService(mocks);

			Account account = AccountBuilder.newAccount().withName('test insert').buildWithoutCommit();

			Application.Service.setMock(ICustomNotificationsService.class, customNotificationsServiceMock);

			Test.startTest();
			Database.executeBatch(SObjectDmlIterator.newInstance(new List<SObject>{ account }, 'insert'), 1);
			Test.stopTest();

			((ICustomNotificationsService)mocks.verify(customNotificationsServiceMock)).notifyUser(UserInfo.getUserId(), Label.SObjectDmlIteratorTitle,
				String.format(Label.SObjectDmlIteratorMessage, new List<Object>{ 1, 0 }));

			List<Account> createdAccounts = [SELECT Id FROM Account WHERE Name = 'test insert'];
			Assert.equals(1, createdAccounts.size());
		}
	}

	@IsTest
	static void runIteratorForUpdateShouldUpdateRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			fflib_ApexMocks mocks = new fflib_ApexMocks();
			ICustomNotificationsService customNotificationsServiceMock = new Mocks.CustomNotificationsService(mocks);

			Account account = TestUtils.selectAccount();
			account.Name = 'Tototo';

			Application.Service.setMock(ICustomNotificationsService.class, customNotificationsServiceMock);

			Test.startTest();
			Database.executeBatch(SObjectDmlIterator.newInstance(new List<SObject>{ account }, 'update'), 1);
			Test.stopTest();

			((ICustomNotificationsService)mocks.verify(customNotificationsServiceMock)).notifyUser(UserInfo.getUserId(), Label.SObjectDmlIteratorTitle,
				String.format(Label.SObjectDmlIteratorMessage, new List<Object>{ 1, 0 }));

			Account accountAfter = [SELECT Name FROM Account WHERE Id = :account.Id];
			Assert.equals('Tototo', accountAfter.Name);
		}
	}

	@IsTest
	static void runIteratorForDeleteShouldDeleteRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			fflib_ApexMocks mocks = new fflib_ApexMocks();
			ICustomNotificationsService customNotificationsServiceMock = new Mocks.CustomNotificationsService(mocks);

			Account account = TestUtils.selectAccount();

			Application.Service.setMock(ICustomNotificationsService.class, customNotificationsServiceMock);

			Test.startTest();
			Database.executeBatch(SObjectDmlIterator.newInstance(new List<SObject>{ account }, 'delete'), 1);
			Test.stopTest();

			((ICustomNotificationsService)mocks.verify(customNotificationsServiceMock)).notifyUser(UserInfo.getUserId(), Label.SObjectDmlIteratorTitle,
				String.format(Label.SObjectDmlIteratorMessage, new List<Object>{ 1, 0 }));

			List<Account> accountsAfter = [SELECT Id FROM Account];
			Assert.isTrue(accountsAfter.isEmpty());
		}
	}
}