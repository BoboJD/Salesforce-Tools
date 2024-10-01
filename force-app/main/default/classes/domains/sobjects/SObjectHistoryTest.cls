@IsTest
private class SObjectHistoryTest{

	@IsTest
	static void updateUserFirstNameShouldCreateSObjectHistory(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			FirstName = 'Test'
		);

		tlz_Users domain = new tlz_Users(new List<User>{ user });

		User userBeforeChange = new User(
			Id = user.Id,
			FirstName = 'FirstName'
		);

		Map<Id, SObject> oldRecordById = new Map<Id, SObject>{ user.Id => userBeforeChange };

		SObjectHistory sObjectHistory = SObjectHistory.handleUpdate(domain, oldRecordById, uowMock);

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectHistory.registerChanges();
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerNew(
			fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
			Schema.SObjectHistory__c.RecordId__c => user.Id,
			Schema.SObjectHistory__c.SObject__c => 'User',
			Schema.SObjectHistory__c.Before__c => JSON.serialize(userBeforeChange),
			Schema.SObjectHistory__c.After__c => JSON.serialize(user)}));
	}

	@IsTest
	static void noUpdateOnUserFirstNameShouldNotCreateSObjectHistory(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);


		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			FirstName = 'FirstName'
		);

		tlz_Users domain = new tlz_Users(new List<User>{ user });

		User userBeforeChange = new User(
			Id = user.Id,
			FirstName = 'FirstName'
		);

		Map<Id, SObject> oldRecordById = new Map<Id, SObject>{ user.Id => userBeforeChange };

		SObjectHistory sObjectHistory = SObjectHistory.handleUpdate(domain, oldRecordById, uowMock);

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectHistory.registerChanges(new List<SObjectField>{ Schema.User.FirstName });
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 0)).registerNew(
			fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
			Schema.SObjectHistory__c.RecordId__c => user.Id,
			Schema.SObjectHistory__c.SObject__c => 'User',
			Schema.SObjectHistory__c.Before__c => JSON.serialize(userBeforeChange),
			Schema.SObjectHistory__c.After__c => JSON.serialize(user)}));
	}
}