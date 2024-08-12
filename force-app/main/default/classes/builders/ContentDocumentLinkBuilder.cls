@IsTest
global inherited sharing class ContentDocumentLinkBuilder extends SObjectBuilder{

	private ContentDocumentLinkBuilder(){
		super();
	}

	global override SObjectType getSObjectType(){
		return ContentDocumentLink.SObjectType;
	}

	global ContentDocumentLink build(){
		return (ContentDocumentLink)buildRecord();
	}

	global static ContentDocumentLinkBuilder newContentDocumentLink(ContentVersion contentVersion, SObject sObj){
		return new ContentDocumentLinkBuilder()
			.withContentDocument(contentVersion)
			.withLinkedEntity(sObj);
	}

	global ContentDocumentLinkBuilder withContentDocument(ContentVersion contentVersion){
		setFieldValue(ContentDocumentLink.ContentDocumentId, contentVersion.ContentDocumentId);
		return this;
	}

	global ContentDocumentLinkBuilder withLinkedEntity(SObject sObj){
		setFieldValue(ContentDocumentLink.LinkedEntityId, sObj.Id);
		return this;
	}
}