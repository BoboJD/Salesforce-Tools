global inherited sharing class tlz_ContentDocumentLinksSelector extends fflib_SObjectSelector implements tlz_IContentDocumentLinksSelector{

	global static tlz_IContentDocumentLinksSelector newInstance(){
		return (tlz_IContentDocumentLinksSelector)Application.Selector.newInstance(ContentDocumentLink.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField> {
			ContentDocumentLink.Id,
			ContentDocumentLink.ContentDocumentId,
			ContentDocumentLink.LinkedEntityId
		};
	}

	global override SObjectType getSObjectType(){
		return ContentDocumentLink.SObjectType;
	}

	global List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds){
		List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
		if(!linkedEntityIds.isEmpty()){
			fflib_QueryFactory query = newQueryFactory()
				.selectFields(new List<String>{ 'ContentDocument.LatestPublishedVersionId' })
				.setCondition('LinkedEntityId IN :linkedEntityIds')
				.setOrdering('ContentDocument.LatestPublishedVersion.CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
			contentDocumentLinks = Database.query(query.toSOQL());
		}
		return contentDocumentLinks;
	}

	global List<ContentDocumentLink> selectByLinkedEntityIdsAndFileTypes(Set<Id> linkedEntityIds, List<String> fileTypes){
		List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
		if(!linkedEntityIds.isEmpty() && !fileTypes.isEmpty()){
			fflib_QueryFactory query = newQueryFactory()
				.selectFields(new List<String>{ 'ContentDocument.LatestPublishedVersionId' })
				.setCondition('LinkedEntityId IN :linkedEntityIds AND ContentDocument.LatestPublishedVersion.tlz__FileType__c IN :fileTypes')
				.setOrdering('ContentDocument.LatestPublishedVersion.CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
			contentDocumentLinks = Database.query(query.toSOQL());
		}
		return contentDocumentLinks;
	}

	global Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds){
		Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = new Map<Id, List<ContentDocumentLink>>();
		if(!contentDocumentIds.isEmpty()){
			fflib_QueryFactory query = newQueryFactory()
				.setCondition('ContentDocumentId = :contentDocumentIds')
				.setOrdering('ContentDocument.LatestPublishedVersion.CreatedDate', fflib_QueryFactory.SortOrder.ASCENDING);
			for(ContentDocumentLink cdl : Database.query(query.toSOQL())){
				if(!contentDocumentLinksByContentDocumentId.containsKey(cdl.ContentDocumentId))
					contentDocumentLinksByContentDocumentId.put(cdl.ContentDocumentId, new List<ContentDocumentLink>());
				contentDocumentLinksByContentDocumentId.get(cdl.ContentDocumentId).add(cdl);
			}
		}
		return contentDocumentLinksByContentDocumentId;
	}
}