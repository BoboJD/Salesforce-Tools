@IsTest
global inherited sharing class ContentVersionBuilder extends SObjectBuilder{

	private ContentVersionBuilder(){
		super();
	}

	global override SObjectType getSObjectType(){
		return ContentVersion.SObjectType;
	}

	global ContentVersion build(){
		ContentVersion contentVersion = (ContentVersion)buildRecord();
		return [SELECT Id, FileType__c, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
	}

	global static ContentVersionBuilder newFile(String title){
		return new ContentVersionBuilder()
			.withTitle(title)
			.withPathOnClient(title)
			.withVersionData(Blob.valueOf('Test'));
	}

	global static ContentVersionBuilder newFile(){
		return newFile('TestFile');
	}

	global ContentVersionBuilder withTitle(String title){
		setFieldValue(ContentVersion.Title, title);
		return this;
	}

	global ContentVersionBuilder withPathOnClient(String pathOnClient){
		setFieldValue(ContentVersion.PathOnClient, pathOnClient);
		return this;
	}

	global ContentVersionBuilder withRecord(SObject record){
		setFieldValue(ContentVersion.RecordId__c, record.Id);
		return this;
	}

	global ContentVersionBuilder withVersionData(Blob versionData){
		setFieldValue(ContentVersion.VersionData, versionData);
		return this;
	}

	global ContentVersionBuilder withJSON(String json){
		setFieldValue(ContentVersion.JSON_fileupload__c, json);
		return this;
	}

	global ContentVersionBuilder withPrivateFile(Boolean privateFile){
		setFieldValue(ContentVersion.PrivateFile__c, privateFile);
		return this;
	}
}