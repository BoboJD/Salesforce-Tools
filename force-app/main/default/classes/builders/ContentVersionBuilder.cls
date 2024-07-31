@IsTest
public inherited sharing class ContentVersionBuilder extends SObjectBuilder{

	private ContentVersionBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return ContentVersion.SObjectType;
	}

	public ContentVersion build(){
		ContentVersion contentVersion = (ContentVersion)buildRecord();
		return [SELECT Id, Type__c, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
	}

	public static ContentVersionBuilder newFile(String title){
		return new ContentVersionBuilder()
			.withTitle(title)
			.withPathOnClient(title)
			.withVersionData(Blob.valueOf('Test'));
	}

	public static ContentVersionBuilder newFile(){
		return newFile('TestFile');
	}

	public ContentVersionBuilder withTitle(String title){
		setFieldValue(ContentVersion.Title, title);
		return this;
	}

	public ContentVersionBuilder withPathOnClient(String pathOnClient){
		setFieldValue(ContentVersion.PathOnClient, pathOnClient);
		return this;
	}

	public ContentVersionBuilder withRecord(SObject record){
		setFieldValue(ContentVersion.RecordId__c, record.Id);
		return this;
	}

	public ContentVersionBuilder withVersionData(Blob versionData){
		setFieldValue(ContentVersion.VersionData, versionData);
		return this;
	}

	public ContentVersionBuilder withJSON(String json){
		setFieldValue(ContentVersion.JSON_fileupload__c, json);
		return this;
	}

	public ContentVersionBuilder withPrivateFile(Boolean privateFile){
		setFieldValue(ContentVersion.PrivateFile__c, privateFile);
		return this;
	}
}