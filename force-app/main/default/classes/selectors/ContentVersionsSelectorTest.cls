@IsTest
private class ContentVersionsSelectorTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			ContentVersionBuilder.newFile().build();
		}
	}

	@IsTest
	static void selectLatestByContentDocumentIdsReturnOneRecord(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			ContentDocument contentDocument = [SELECT Id FROM ContentDocument LIMIT 1];

			Test.startTest();
			List<ContentVersion> contentVersions = ContentVersionsSelector.newInstance().selectLatestByContentDocumentIds(new Set<Id>{contentDocument.Id});
			Test.stopTest();

			Assert.equals(1, contentVersions.size());
		}
	}
}