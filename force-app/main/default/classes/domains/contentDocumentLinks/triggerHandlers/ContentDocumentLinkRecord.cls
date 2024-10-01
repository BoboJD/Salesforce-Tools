global with sharing class ContentDocumentLinkRecord extends ContentDocumentLinksHandler{

	private Map<Id, ContentDocument> contentDocumentById{
		get{
			if(contentDocumentById == null)
				contentDocumentById = ContentDocumentLinkShareType.storedContentDocumentById;
			return contentDocumentById;
		}set;
	}

	private ContentDocumentLinkRecord(tlz_ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	global static ContentDocumentLinkRecord handleInsert(tlz_ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		return new ContentDocumentLinkRecord(domain, uow);
	}

	global void updateRecordIdIfEmpty(){
		for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
			if(relatedToRecord(contentDocumentLink) && recordIdIsEmpty(contentDocumentLink)){
				ContentDocument cd = contentDocumentById.get(contentDocumentLink.ContentDocumentId);
				uow.registerDirty(new ContentVersion(
					Id = cd.LatestPublishedVersionId,
					RecordId__c = contentDocumentLink.LinkedEntityId,
					RelatedToRecord__c = true
				), new List<SObjectField>{
					Schema.ContentVersion.RecordId__c,
					Schema.ContentVersion.RelatedToRecord__c
				});
			}
		}
	}

	private Boolean relatedToRecord(ContentDocumentLink contentDocumentLink){
		return contentDocumentLink.LinkedEntityId.getSObjectType() != Schema.User.SObjectType;
	}

	private Boolean recordIdIsEmpty(ContentDocumentLink contentDocumentLink){
		ContentDocument cd = contentDocumentById.get(contentDocumentLink.ContentDocumentId);
		return cd.LatestPublishedVersion.RecordId__c == null;
	}
}