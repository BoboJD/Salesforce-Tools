@IsTest
private class ContentVersionRecordRelationTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void createContentVersionShouldCreateContentDocumentLinkRelatedToTheRecordId(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			ContentVersion cv = ContentVersionBuilder.newFile('Test')
				.withRecord(account)
				.build();
			Test.stopTest();

			List<ContentDocumentLink> contentDocumentLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :account.Id];
			Assert.equals(1, contentDocumentLinks.size());
			ContentVersion contentVersionAfter = [SELECT RelatedToRecord__c, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
			Assert.isTrue(contentVersionAfter.RelatedToRecord__c);
		}
	}
}