@IsTest
private class FileRecordIdUpdateJobTest{

	@TestSetup
	static void setup(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
			ContentVersionBuilder.newFile().build();
		}
	}

	@IsTest
	static void runBatchWithoutLinkOnAccountShouldFlagFileToUnrelatedRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Test.startTest();
			Database.executeBatch(FileRecordIdUpdateJob.instanceForNewRecords());
			Test.stopTest();

			ContentVersion contentVersionAfter = [SELECT LastCheckOfRelationship__c, UnrelatedToRecords__c FROM ContentVersion WHERE ContentDocument.Title = 'TestFile' LIMIT 1];
			Assert.equals(DateUtils.now(), contentVersionAfter.LastCheckOfRelationship__c);
			Assert.isTrue(contentVersionAfter.UnrelatedToRecords__c);
		}
	}

	@IsTest
	static void runBatchWithoutLinkOnAccountShouldNotFlagFileToUnrelatedRecords(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			Account account = TestUtils.selectAccount();
			ContentVersion contentVersion = TestUtils.selectContentVersion();
			ContentDocumentLinkBuilder.newContentDocumentLink(contentVersion, account).build();

			Test.startTest();
			Database.executeBatch(FileRecordIdUpdateJob.instanceForNewRecords());
			Test.stopTest();

			ContentVersion contentVersionAfter = [SELECT LastCheckOfRelationship__c, UnrelatedToRecords__c, RecordId__c FROM ContentVersion WHERE ContentDocument.Title = 'TestFile' LIMIT 1];
			Assert.equals(DateUtils.now(), contentVersionAfter.LastCheckOfRelationship__c);
			Assert.isFalse(contentVersionAfter.UnrelatedToRecords__c);
			Assert.equals(account.Id, contentVersionAfter.RecordId__c);
		}
	}

	@IsTest
	static void runBatchWithLinkOnContentWorkspaceShouldSetFileToExcludedFiles(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			ContentWorkspace contentWorkspace = new ContentWorkspace(Name = 'Workspace');
			insert contentWorkspace;
			ContentVersion contentVersion = TestUtils.selectContentVersion();
			ContentDocumentLinkBuilder.newContentDocumentLink(contentVersion, contentWorkspace).build();

			Test.startTest();
			Database.executeBatch(FileRecordIdUpdateJob.instanceForAllRecords());
			Test.stopTest();

			ContentVersion contentVersionAfter = [SELECT LastCheckOfRelationship__c, UnrelatedToRecords__c FROM ContentVersion WHERE ContentDocument.Title = 'TestFile' LIMIT 1];
			Assert.isNull(contentVersionAfter.LastCheckOfRelationship__c);
		}
	}
}