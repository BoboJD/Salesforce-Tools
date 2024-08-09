global inherited sharing class ContentDocumentsSelector extends fflib_SObjectSelector implements IContentDocumentsSelector{

	global static IContentDocumentsSelector newInstance(){
		return (IContentDocumentsSelector)Application.Selector.newInstance(ContentDocument.SObjectType);
	}

	global List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			ContentDocument.Id,
			ContentDocument.LatestPublishedVersionId,
			ContentDocument.SharingPrivacy
		};
	}

	global SObjectType getSObjectType(){
		return ContentDocument.SObjectType;
	}

	global List<ContentDocument> selectByIds(Set<Id> contentDocumentIds){
		List<ContentDocument> contentDocuments = new List<ContentDocument>();
		if(!contentDocumentIds.isEmpty()){
			contentDocuments = Database.query(newQueryFactory()
				.selectFields(new List<String>{'LatestPublishedVersion.RecordId__c'})
				.setCondition('Id IN :contentDocumentIds')
				.toSOQL());
		}
		return contentDocuments;
	}
}