global inherited sharing class ContentVersionsSelector extends fflib_SObjectSelector implements IContentVersionsSelector{

	global static IContentVersionsSelector newInstance(){
		return (IContentVersionsSelector)Application.Selector.newInstance(ContentVersion.SObjectType);
	}

	global List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			ContentVersion.Id,
			ContentVersion.ContentDocumentId,
			ContentVersion.ContentSize,
			ContentVersion.CreatedDate,
			ContentVersion.FileExtension,
			ContentVersion.FileType,
			ContentVersion.Title,
			ContentVersion.Type__c
		};
	}

	global SObjectType getSObjectType(){
		return ContentVersion.SObjectType;
	}

	global List<ContentVersion> selectLatestByContentDocumentIds(Set<Id> contentDocumentIds){
		List<ContentVersion> contentVersions = new List<ContentVersion>();
		if(!contentDocumentIds.isEmpty()){
			fflib_QueryFactory query = newQueryFactory()
				.setCondition('IsLatest = TRUE AND ContentDocumentId IN :contentDocumentIds')
				.setOrdering(ContentVersion.CreatedDate, fflib_QueryFactory.SortOrder.DESCENDING);
			contentVersions = Database.query(query.toSOQL());
		}
		return contentVersions;
	}
}