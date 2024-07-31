public inherited sharing class ContentDocumentsSelector extends fflib_SObjectSelector implements IContentDocumentsSelector{

	public static IContentDocumentsSelector newInstance(){
		return (IContentDocumentsSelector)Application.Selector.newInstance(ContentDocument.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			ContentDocument.Id,
			ContentDocument.LatestPublishedVersionId,
			ContentDocument.SharingPrivacy
		};
	}

	public SObjectType getSObjectType(){
		return ContentDocument.SObjectType;
	}

	public List<ContentDocument> selectByIds(Set<Id> contentDocumentIds){
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