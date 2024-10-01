@IsTest
private class TriggerHandlerTest{

	@IsTest
	static void isNewShouldReturnFalse(){
		TriggerHandler handler = new TriggerHandler();

		Test.startTest();
		Assert.isFalse(handler.isNew);
		Test.stopTest();
	}

	@IsTest
	static void isDeletedShouldReturnFalse(){
		TriggerHandler handler = new TriggerHandler();

		Test.startTest();
		Assert.isFalse(handler.isDeleted);
		Test.stopTest();
	}

	@IsTest
	static void hasChangedWithSameValueShouldReturnFalse(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			FirstName = 'Test'
		);
		List<SObject> records = new List<User>{ user };
		User oldUser = new User(FirstName = 'Test');
		Map<Id, User> oldRecordById = new Map<Id, User>{ user.Id => oldUser };
		TriggerHandler handler = new TriggerHandler(new tlz_Users(records), oldRecordById);

		Test.startTest();
		Assert.isFalse(handler.hasChanged(user, Schema.User.FirstName));
		Test.stopTest();
	}

	@IsTest
	static void hasChangedWithDifferentValueShouldReturnTrue(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			FirstName = 'Test'
		);
		List<SObject> records = new List<User>{ user };
		User oldUser = new User(FirstName = 'Toto');
		Map<Id, User> oldRecordById = new Map<Id, User>{ user.Id => oldUser };

		TriggerHandler handler = new TriggerHandler(new tlz_Users(records), oldRecordById);

		Test.startTest();
		Assert.isTrue(handler.hasChanged(user, Schema.User.FirstName));
		Assert.isTrue(handler.hasChanged(user, 'FirstName'));
		Assert.isTrue(handler.hasChanged(user, new Set<SObjectField>{ Schema.User.FirstName }));
		Test.stopTest();
	}

	@IsTest
	static void hasBeenFilledWithoutValueOnCreationShouldReturnFalse(){
		User user = new User();
		List<SObject> records = new List<User>{ user };

		TriggerHandler handler = new TriggerHandler(new tlz_Users(records));

		Test.startTest();
		Assert.isFalse(handler.hasBeenFilled(user, Schema.User.FirstName));
		Test.stopTest();
	}

	@IsTest
	static void hasBeenRemovedWithSameValueShouldReturnFalse(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			FirstName = 'Toto'
		);
		List<SObject> records = new List<User>{ user };
		User oldUser = new User(FirstName = 'Toto');
		Map<Id, User> oldRecordById = new Map<Id, User>{ user.Id => oldUser };

		TriggerHandler handler = new TriggerHandler(new tlz_Users(records), oldRecordById);

		Test.startTest();
		Assert.isFalse(handler.hasBeenRemoved(user, Schema.User.FirstName));
		Test.stopTest();
	}

	@IsTest
	static void hasBeenRemovedWithDifferentValueShouldReturnTrue(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType)
		);
		List<SObject> records = new List<User>{ user };
		User oldUser = new User(FirstName = 'Toto');
		Map<Id, User> oldRecordById = new Map<Id, User>{ user.Id => oldUser };

		TriggerHandler handler = new TriggerHandler(new tlz_Users(records), oldRecordById);

		Test.startTest();
		Assert.isTrue(handler.hasBeenRemoved(user, Schema.User.FirstName));
		Test.stopTest();
	}

	@IsTest
	static void recordIdsShouldReturnSetIdOfCurrentRecords(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType)
		);
		List<SObject> records = new List<User>{ user };
		TriggerHandler handler = new TriggerHandler(new tlz_Users(records));

		Test.startTest();
		Assert.equals(new Set<Id>{ user.Id }, handler.recordIds);
		Test.stopTest();
	}

	@IsTest
	static void setIdsShouldReturnSetIdOfCurrentRecords(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType),
			ProfileId = fflib_IDGenerator.generate(Schema.Profile.SObjectType)
		);
		List<SObject> records = new List<User>{ user };
		TriggerHandler handler = new TriggerHandler(new tlz_Users(records));

		Test.startTest();
		Assert.equals(new Set<Id>{ user.ProfileId }, handler.setIds(Schema.User.ProfileId));
		Test.stopTest();
	}

	@IsTest
	static void constructorCoverage(){
		User user = new User(
			Id = fflib_IDGenerator.generate(Schema.User.SObjectType)
		);
		List<SObject> records = new List<User>{ user };
		User oldUser = new User(FirstName = 'Toto');
		Map<Id, User> oldRecordById = new Map<Id, User>{ user.Id => oldUser };
		new TriggerHandler(new tlz_Users(records), Application.UnitOfWork.newInstance());
		new TriggerHandler(new tlz_Users(records), oldRecordById, Application.UnitOfWork.newInstance());
	}
}