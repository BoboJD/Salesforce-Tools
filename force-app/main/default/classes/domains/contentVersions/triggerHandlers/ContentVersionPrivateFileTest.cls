@IsTest
private class ContentVersionPrivateFileTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}


	@IsTest
	static void insertContentVersionWithPrivateFileShouldUpdateContentDocumentPrivacy(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			ContentVersion cv = ContentVersionBuilder.newFile().withRecord(account).withPrivateFile(true).build();
			Test.stopTest();

			ContentDocument contentDocumentAfter = [SELECT SharingPrivacy FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
			Assert.equals(ContentDocumentConstants.SHARINGPRIVACY_PRIVATE, contentDocumentAfter.SharingPrivacy);
		}
	}
}