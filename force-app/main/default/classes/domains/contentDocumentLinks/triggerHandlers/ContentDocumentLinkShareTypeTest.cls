@IsTest
private class ContentDocumentLinkShareTypeTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
		}
	}

	@IsTest
	static void linkContentDocumentOnAccountShouldSetShareTypeIAndVisibilityAll(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			ContentVersion cv = ContentVersionBuilder.newFile().build();
			Account account = TestUtils.selectAccount();

			Test.startTest();
			ContentDocumentLink cdl = ContentDocumentLinkBuilder.newContentDocumentLink(cv, account).build();
			Test.stopTest();

			ContentDocumentLink cdlAfter = [SELECT ShareType, Visibility FROM ContentDocumentLink WHERE Id = :cdl.Id];
			Assert.equals(ContentDocumentLinkConstants.SHARETYPE_I, cdlAfter.ShareType);
			Assert.equals(ContentDocumentLinkConstants.VISIBILITY_ALL, cdlAfter.Visibility);
		}
	}
}