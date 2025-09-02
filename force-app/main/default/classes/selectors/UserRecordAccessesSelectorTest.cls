@IsTest
private class UserRecordAccessesSelectorTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void canEditRecordShouldReturnTrue(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Boolean canEditRecord = UserRecordAccessesSelector.newInstance().canEditRecord(standardUser.Id, account.Id);
			Test.stopTest();

			tlz.Assert.isTrue(canEditRecord);
		}
	}

	@IsTest
	static void canEditRecordShouldReturnFalse(){
		User chatterFreeUser = UserBuilder.newChatterFreeUser().build();
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Boolean canEditRecord = UserRecordAccessesSelector.newInstance().canEditRecord(chatterFreeUser.Id, account.Id);
			Test.stopTest();

			tlz.Assert.isFalse(canEditRecord);
		}
	}

	@IsTest
	static void canEditRecordsShouldReturnTrue(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Map<Id, Boolean> editRightByRecordId = UserRecordAccessesSelector.newInstance().canEditRecords(standardUser.Id, new Set<Id>{account.Id});
			Test.stopTest();

			tlz.Assert.isTrue(editRightByRecordId.get(account.Id));
		}
	}

	@IsTest
	static void canEditRecordsShouldReturnFalse(){
		User chatterFreeUser = UserBuilder.newChatterFreeUser().build();
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Map<Id, Boolean> editRightByRecordId = UserRecordAccessesSelector.newInstance().canEditRecords(chatterFreeUser.Id, new Set<Id>{account.Id});
			Test.stopTest();

			tlz.Assert.isFalse(editRightByRecordId.get(account.Id));
		}
	}

	@IsTest
	static void canDeleteRecordsShouldReturnTrue(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Map<Id, Boolean> deleteRightByRecordId = UserRecordAccessesSelector.newInstance().canDeleteRecords(standardUser.Id, new Set<Id>{account.Id});
			Test.stopTest();

			tlz.Assert.isTrue(deleteRightByRecordId.get(account.Id));
		}
	}

	@IsTest
	static void canDeleteRecordsShouldReturnFalse(){
		User chatterFreeUser = UserBuilder.newChatterFreeUser().build();
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			Map<Id, Boolean> deleteRightByRecordId = UserRecordAccessesSelector.newInstance().canDeleteRecords(chatterFreeUser.Id, new Set<Id>{account.Id});
			Test.stopTest();

			tlz.Assert.isFalse(deleteRightByRecordId.get(account.Id));
		}
	}
}