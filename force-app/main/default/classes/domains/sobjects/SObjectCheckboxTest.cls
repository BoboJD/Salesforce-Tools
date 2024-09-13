@IsTest
private class SObjectCheckboxTest{

	@IsTest
	static void setCheckboxFieldToTrueShouldUncheckItAfterInsert(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			ReceivesAdminInfoEmails = true
		);

		Users domain = new Users(new List<User>{ user });

		SObjectCheckbox sObjectCheckbox = SObjectCheckbox.handleInsert(domain, uowMock);
		sObjectCheckbox.forceIsNew = true;

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectCheckbox.uncheckField(Schema.User.ReceivesAdminInfoEmails);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerDirty(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.User.Id => user.Id,
				Schema.User.ReceivesAdminInfoEmails => false}),
			(List<SObjectField>)fflib_Match.eqList(new List<SObjectField>{ Schema.User.ReceivesAdminInfoEmails }));
	}

	@IsTest
	static void setCheckboxFieldToFalseShouldDoNothingAfterInsert(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			ReceivesAdminInfoEmails = false
		);

		Users domain = new Users(new List<User>{ user });

		SObjectCheckbox sObjectCheckbox = SObjectCheckbox.handleInsert(domain, uowMock);
		sObjectCheckbox.forceIsNew = true;

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectCheckbox.uncheckField(Schema.User.ReceivesAdminInfoEmails);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 0)).registerDirty(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.User.Id => user.Id,
				Schema.User.ReceivesAdminInfoEmails => false}),
			(List<SObjectField>)fflib_Match.eqList(new List<SObjectField>{ Schema.User.ReceivesAdminInfoEmails }));
	}

	@IsTest
	static void setCheckboxFieldToTrueShouldUncheckItAfterUpdate(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			ReceivesAdminInfoEmails = true
		);

		Users domain = new Users(new List<User>{ user });

		User userBeforeChange = new User(
			Id = user.Id,
			ReceivesAdminInfoEmails = false
		);

		Map<Id, SObject> oldRecordById = new Map<Id, SObject>{ user.Id => userBeforeChange };

		SObjectCheckbox sObjectCheckbox = SObjectCheckbox.handleUpdate(domain, oldRecordById, uowMock);

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectCheckbox.uncheckField(Schema.User.ReceivesAdminInfoEmails);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerDirty(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.User.Id => user.Id,
				Schema.User.ReceivesAdminInfoEmails => false}),
			(List<SObjectField>)fflib_Match.eqList(new List<SObjectField>{ Schema.User.ReceivesAdminInfoEmails }));
	}

	@IsTest
	static void noChangesOnCheckboxShouldDoNothingAfterUpdate(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			ReceivesAdminInfoEmails = false
		);

		Users domain = new Users(new List<User>{ user });

		User userBeforeChange = new User(
			Id = user.Id,
			ReceivesAdminInfoEmails = false
		);

		Map<Id, SObject> oldRecordById = new Map<Id, SObject>{ user.Id => userBeforeChange };

		SObjectCheckbox sObjectCheckbox = SObjectCheckbox.handleUpdate(domain, oldRecordById, uowMock);

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		sObjectCheckbox.uncheckField(Schema.User.ReceivesAdminInfoEmails);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 0)).registerDirty(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.User.Id => user.Id,
				Schema.User.ReceivesAdminInfoEmails => false}),
			(List<SObjectField>)fflib_Match.eqList(new List<SObjectField>{ Schema.User.ReceivesAdminInfoEmails }));
	}
}