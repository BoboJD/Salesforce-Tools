global inherited sharing class tlz_ContentDocumentsSelector extends fflib_SObjectSelector implements tlz_IContentDocumentsSelector{

	global static tlz_IContentDocumentsSelector newInstance(){
		return (tlz_IContentDocumentsSelector)Application.Selector.newInstance(ContentDocument.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			ContentDocument.Id,
			ContentDocument.LatestPublishedVersionId,
			ContentDocument.SharingPrivacy
		};
	}

	global override SObjectType getSObjectType(){
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