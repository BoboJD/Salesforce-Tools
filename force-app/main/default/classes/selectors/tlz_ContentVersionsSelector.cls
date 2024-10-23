global inherited sharing class tlz_ContentVersionsSelector extends fflib_SObjectSelector implements tlz_IContentVersionsSelector{

	global static tlz_IContentVersionsSelector newInstance(){
		return (tlz_IContentVersionsSelector)Application.Selector.newInstance(ContentVersion.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			ContentVersion.Id,
			ContentVersion.ContentDocumentId,
			ContentVersion.ContentSize,
			ContentVersion.CreatedDate,
			ContentVersion.FileExtension,
			ContentVersion.FileType,
			ContentVersion.FileType__c,
			ContentVersion.Title
		};
	}

	global override SObjectType getSObjectType(){
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