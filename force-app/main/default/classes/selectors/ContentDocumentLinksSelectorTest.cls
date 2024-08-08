@IsTest
private class ContentDocumentLinksSelectorTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();
			ContentVersionBuilder.newFile().withRecord(account).build();
		}
	}

	@IsTest
	static void selectByLinkedEntityIdsShouldReturnOneRecord(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();

			Test.startTest();
			List<ContentDocumentLink> records = ContentDocumentLinksSelector.newInstance().selectByLinkedEntityIds(new Set<Id>{account.Id});
			Test.stopTest();

			Assert.equals(1, records.size());
		}
	}

	@IsTest
	static void mapByContentDocumentIdShouldReturnMappedData(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			ContentDocument contentDocument = [SELECT Id FROM ContentDocument LIMIT 1];

			Test.startTest();
			Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = ContentDocumentLinksSelector.newInstance().mapByContentDocumentId(new Set<Id>{contentDocument.Id});
			Test.stopTest();

			Assert.isTrue(contentDocumentLinksByContentDocumentId.containsKey(contentDocument.Id));
		}
	}
}