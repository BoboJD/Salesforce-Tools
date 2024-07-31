public with sharing class ContentVersionPrivateFile extends ContentVersionsHandler{

	private ContentVersionPrivateFile(ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	public static ContentVersionPrivateFile handleInsert(ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		return new ContentVersionPrivateFile(domain, uow);
	}

	public void handlePrivateFile(){
		for(ContentVersion contentVersion : contentVersions){
			if(contentVersion.PrivateFile__c){
				uow.registerDirty(new ContentDocument(
					Id = contentVersion.ContentDocumentId,
					SharingPrivacy = ContentDocumentConstants.SHARINGPRIVACY_PRIVATE
				), new List<SObjectField>{
					Schema.ContentDocument.SharingPrivacy
				});
			}
		}
	}
}