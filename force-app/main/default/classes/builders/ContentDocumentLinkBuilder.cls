@IsTest
public inherited sharing class ContentDocumentLinkBuilder extends SObjectBuilder{

	private ContentDocumentLinkBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return ContentDocumentLink.SObjectType;
	}

	public ContentDocumentLink build(){
		return (ContentDocumentLink)buildRecord();
	}

	public static ContentDocumentLinkBuilder newContentDocumentLink(ContentVersion contentVersion, SObject sObj){
		return new ContentDocumentLinkBuilder()
			.withContentDocument(contentVersion)
			.withLinkedEntity(sObj);
	}

	public ContentDocumentLinkBuilder withContentDocument(ContentVersion contentVersion){
		setFieldValue(ContentDocumentLink.ContentDocumentId, contentVersion.ContentDocumentId);
		return this;
	}

	public ContentDocumentLinkBuilder withLinkedEntity(SObject sObj){
		setFieldValue(ContentDocumentLink.LinkedEntityId, sObj.Id);
		return this;
	}
}