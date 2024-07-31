@IsTest
private class ContentDocumentLinkRecordTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void linkFileOnAccountShouldFillRecordIdOnContentVersionWithAccountnId(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();
			ContentVersion cv = ContentVersionBuilder.newFile().build();

			Test.startTest();
			ContentDocumentLinkBuilder.newContentDocumentLink(cv, account).build();
			Test.stopTest();

			ContentVersion contentVersionAfter = [SELECT RecordId__c, RelatedToRecord__c FROM ContentVersion WHERE Id = :cv.Id];
			Assert.equals(account.Id, contentVersionAfter.RecordId__c);
			Assert.isTrue(contentVersionAfter.RelatedToRecord__c);
		}
	}
}