@IsTest
private class FileUploaderControllerTest{

	@IsTest
	static void getUtilityDataFromAccountShouldReturn6MappedData(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IContentDocumentLinksSelector contentDocumentLinksSelectorMock = new Mocks.tlz_ContentDocumentLinksSelector(mocks);
		tlz_IContentVersionsSelector contentVersionsSelectorMock = new Mocks.tlz_ContentVersionsSelector(mocks);

		Account account = new Account(
			Id = fflib_IDGenerator.generate(Schema.Account.SObjectType)
		);
		Id contentDocumentId = fflib_IDGenerator.generate(Schema.ContentDocument.SObjectType);
		ContentDocumentLink cdl = new ContentDocumentLink(
			ContentDocumentId = contentDocumentId,
			LinkedEntityId = account.Id
		);
		ContentVersion cv = (ContentVersion)TestUtils.setReadableFields(new ContentVersion(
			Id = fflib_IDGenerator.generate(Schema.ContentVersion.SObjectType),
			Title = 'Test',
			ContentDocumentId = contentDocumentId,
			FileType__c = 'contrat'
		), new Map<SObjectField, Object>{
			Schema.ContentVersion.ContentSize => (1024 * 1024 * 2),
			Schema.ContentVersion.FileExtension => 'pdf',
			Schema.ContentVersion.CreatedDate => System.now()
		});

		Set<Id> recordIds = new Set<Id>{account.Id};

		mocks.startStubbing();
		mocks.when(contentDocumentLinksSelectorMock.sObjectType()).thenReturn(Schema.ContentDocumentLink.SObjectType);
		mocks.when(contentDocumentLinksSelectorMock.selectByLinkedEntityIds(recordIds)).thenReturn(new List<ContentDocumentLink>{cdl});
		mocks.when(contentVersionsSelectorMock.sObjectType()).thenReturn(Schema.ContentVersion.SObjectType);
		mocks.when(contentVersionsSelectorMock.selectLatestByContentDocumentIds(new Set<Id>{contentDocumentId})).thenReturn(new List<ContentVersion>{cv});
		mocks.stopStubbing();

		Application.Selector.setMock(contentDocumentLinksSelectorMock);
		Application.Selector.setMock(contentVersionsSelectorMock);

		Test.startTest();
		Map<String, Object> utilityData = FileUploaderController.getUtilityData(account.Id);
		Test.stopTest();

		((tlz_IContentDocumentLinksSelector)mocks.verify(contentDocumentLinksSelectorMock)).selectByLinkedEntityIds(recordIds);
		((tlz_IContentVersionsSelector)mocks.verify(contentVersionsSelectorMock)).selectLatestByContentDocumentIds(new Set<Id>{contentDocumentId});

		Assert.equals(6, utilityData.size());
		List<FilePreview> filePreviews = (List<FilePreview>)utilityData.get('files');
		Assert.equals(1, filePreviews.size());
		Assert.equals(2, filePreviews[0].size);
		Assert.equals('MB', filePreviews[0].sizeUnit);
		Assert.isTrue(filePreviews[0].previewLink.contains('/sfc/servlet.shepherd/version'));
		List<DecoratedPicklistEntry> fileTypes = (List<DecoratedPicklistEntry>)utilityData.get('fileTypes');
		Assert.isFalse(fileTypes?.isEmpty());
		Assert.isTrue(utilityData.get('isAdmin'));
		Assert.isTrue(utilityData.containsKey('hasEditAccess'));
		Assert.isTrue(utilityData.containsKey('config'));
		Assert.equals('Account', utilityData.get('sObjectType'));
	}

	@IsTest
	static void deleteFilesShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
		tlz_IContentDocumentLinksSelector contentDocumentLinksSelectorMock = new Mocks.tlz_ContentDocumentLinksSelector(mocks);

		Id contentDocumentId = fflib_IDGenerator.generate(Schema.ContentDocument.SObjectType);
		Id contentDocumentLinkToDeleteId = fflib_IDGenerator.generate(Schema.ContentDocumentLink.SObjectType);
		Id contentDocumentToDeleteId = fflib_IDGenerator.generate(Schema.ContentDocument.SObjectType);
		Id contentDocumentLinkId = fflib_IDGenerator.generate(Schema.ContentDocumentLink.SObjectType);

		Set<Id> contentDocumentIds = new Set<Id>{ contentDocumentId, contentDocumentToDeleteId };

		Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = new Map<Id, List<ContentDocumentLink>>{
			contentDocumentId => new List<ContentDocumentLink>{
				new ContentDocumentLink(Id = contentDocumentLinkToDeleteId, LinkedEntityId = fflib_IDGenerator.generate(Schema.Contact.SObjectType)),
				new ContentDocumentLink(LinkedEntityId = fflib_IDGenerator.generate(Schema.User.SObjectType)),
				new ContentDocumentLink(LinkedEntityId = fflib_IDGenerator.generate(Schema.Account.SObjectType))
			},
			contentDocumentToDeleteId => new List<ContentDocumentLink>{
				new ContentDocumentLink(Id = contentDocumentLinkId, LinkedEntityId = fflib_IDGenerator.generate(Schema.Contact.SObjectType)),
				new ContentDocumentLink(LinkedEntityId = fflib_IDGenerator.generate(Schema.User.SObjectType))
			}
		};

		String filesToDeleteJSON = JSON.serialize(new List<FilePreview>{
			new FilePreview(new ContentVersion(ContentDocumentId = contentDocumentId), contentDocumentLinkToDeleteId, true),
			new FilePreview(new ContentVersion(ContentDocumentId = contentDocumentToDeleteId), contentDocumentLinkId, true)
		});

		mocks.startStubbing();
		mocks.when(contentDocumentLinksSelectorMock.sObjectType()).thenReturn(Schema.ContentDocumentLink.SObjectType);
		mocks.when(contentDocumentLinksSelectorMock.mapByContentDocumentId(contentDocumentIds)).thenReturn(contentDocumentLinksByContentDocumentId);
		mocks.stopStubbing();

		Application.Selector.setMock(contentDocumentLinksSelectorMock);
		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		Map<String, Object> result = FileUploaderController.deleteFiles(filesToDeleteJSON);
		Test.stopTest();

		((tlz_IContentDocumentLinksSelector)mocks.verify(contentDocumentLinksSelectorMock)).mapByContentDocumentId(contentDocumentIds);
		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerDeleted(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.ContentDocumentLink.Id => contentDocumentLinkToDeleteId}));
		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerDeleted(
			fflib_Match.sObjectWith(new Map<SObjectField, Object>{
				Schema.ContentDocument.Id => contentDocumentToDeleteId}));
		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).commitWork();

		Assert.success(result);
	}

	@IsTest
	static void deleteFilesWithNullParameterShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = FileUploaderController.deleteFiles(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void deleteFileShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);

		Id contentDocumentId = fflib_IDGenerator.generate(Schema.ContentDocument.SObjectType);

		Application.UnitOfWork.setMock(uowMock);

		Test.startTest();
		Map<String, Object> result = FileUploaderController.deleteFile(contentDocumentId);
		Test.stopTest();

		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).registerDeleted(fflib_Match.sObjectWithId(contentDocumentId));
		((fflib_ISObjectUnitOfWork)mocks.verify(uowMock)).commitWork();

		Assert.success(result);
	}

	@IsTest
	static void deleteFileShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = FileUploaderController.deleteFile(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}
}