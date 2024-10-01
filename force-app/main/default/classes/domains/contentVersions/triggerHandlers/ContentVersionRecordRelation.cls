global with sharing class ContentVersionRecordRelation extends ContentVersionsHandler{

	private ContentVersionRecordRelation(tlz_ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	global static ContentVersionRecordRelation handleInsert(tlz_ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		return new ContentVersionRecordRelation(domain, uow);
	}

	global void handleRecordIdIfFilled(){
		for(ContentVersion contentVersion : contentVersions){
			if(String.isNotBlank(contentVersion.RecordId__c) && !contentVersion.RelatedToRecord__c){
				uow.registerNew(new ContentDocumentLink(
					ContentDocumentId = contentVersion.ContentDocumentId,
					LinkedEntityId = contentVersion.RecordId__c
				));
				uow.registerDirty(new ContentVersion(
					Id = contentVersion.Id,
					RelatedToRecord__c = true
				), new List<SObjectField>{
					Schema.ContentVersion.RelatedToRecord__c
				});
			}
		}
	}
}