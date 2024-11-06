@IsTest
private class CurrentUserTest{

	@IsTest
	static void isAdminAsStandardUserShouldReturnFalse(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Test.startTest();
			Boolean isAdmin = CurrentUser.isAdmin();
			Test.stopTest();

			Assert.isFalse(isAdmin);
		}
	}

	@IsTest
	static void isAdminAsStandardUserWithAdminCheckedShouldReturnTrue(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Test.startTest();
			Boolean isAdmin = CurrentUser.isAdmin();
			Test.stopTest();

			Assert.isTrue(isAdmin);
		}
	}

	@IsTest
	static void isAdminAsSysAdminShouldReturnTrue(){
		Test.startTest();
		Boolean isAdmin = CurrentUser.isAdmin();
		Test.stopTest();

		Assert.isTrue(isAdmin);
	}

	@IsTest
	static void canEditRecordShouldReturnTrue(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();

			Test.startTest();
			Boolean canEditRecord = CurrentUser.canEditRecord(account.Id);
			Test.stopTest();

			Assert.isTrue(canEditRecord);
		}
	}

	@IsTest
	static void canEditRecordWithFakeIdShouldReturnFalse(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Id fakeId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

			Test.startTest();
			Boolean canEditRecord = CurrentUser.canEditRecord(fakeId);
			Test.stopTest();

			Assert.isFalse(canEditRecord);
		}
	}

	@IsTest
	static void canEditRecordsShouldReturnTrue(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();

			Test.startTest();
			Map<Id, Boolean> editRightByRecordId = CurrentUser.canEditRecords(new Set<Id>{account.Id});
			Test.stopTest();

			Assert.isTrue(editRightByRecordId.get(account.Id));
		}
	}

	@IsTest
	static void canEditRecordsWithFakeIdShouldReturnFalse(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Id fakeId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

			Test.startTest();
			Map<Id, Boolean> editRightByRecordId = CurrentUser.canEditRecords(new Set<Id>{fakeId});
			Test.stopTest();

			Assert.isFalse(editRightByRecordId.get(fakeId));
		}
	}

	@IsTest
	static void canDeleteRecordsShouldReturnTrue(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();

			Test.startTest();
			Map<Id, Boolean> deleteRightByRecordId = CurrentUser.canDeleteRecords(new Set<Id>{account.Id});
			Test.stopTest();

			Assert.isTrue(deleteRightByRecordId.get(account.Id));
		}
	}

	@IsTest
	static void canDeleteRecordsWithFakeIdShouldReturnFalse(){
		User standardUser = UserBuilder.newStandardUser().withAdmin(true).build();
		System.runAs(standardUser){
			Id fakeId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

			Test.startTest();
			Map<Id, Boolean> deleteRightByRecordId = CurrentUser.canDeleteRecords(new Set<Id>{fakeId});
			Test.stopTest();

			Assert.isFalse(deleteRightByRecordId.get(fakeId));
		}
	}
}