@IsTest
private class DatacloudServiceTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			ContactBuilder.build(new List<ContactBuilder>{
				ContactBuilder.newContact().withEmail('toto@toto.fr'),
				ContactBuilder.newContact().withEmail('tata@toto.fr')
			});
		}
	}

	@IsTest
	static void findDuplicatesWithContactWithoutSameEmailShouldNotReturnRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Contact contact = [SELECT Id, Email FROM Contact WHERE Email = 'toto@toto.fr'];

			Test.startTest();
			List<SObject> duplicatesRecords = DatacloudService.findDuplicates(contact);
			Test.stopTest();

			Assert.isTrue(duplicatesRecords.isEmpty());
		}
	}

	@IsTest
	static void findDuplicatesWithContactWithSameEmailShouldReturnOneRecord(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Contact contact = [SELECT Id, Email FROM Contact WHERE Email = 'toto@toto.fr'];
			contact.Email = 'tata@toto.fr';

			Test.startTest();
			List<SObject> duplicatesRecords = DatacloudService.findDuplicates(contact);
			Test.stopTest();

			Assert.isFalse(duplicatesRecords.isEmpty());
		}
	}
}