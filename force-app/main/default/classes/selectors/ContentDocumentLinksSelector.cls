public inherited sharing class ContentDocumentLinksSelector extends fflib_SObjectSelector implements IContentDocumentLinksSelector{

	public static IContentDocumentLinksSelector newInstance(){
		return (IContentDocumentLinksSelector)Application.Selector.newInstance(ContentDocumentLink.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField> {
			ContentDocumentLink.Id,
			ContentDocumentLink.ContentDocumentId,
			ContentDocumentLink.LinkedEntityId
		};
	}

	public SObjectType getSObjectType(){
		return ContentDocumentLink.SObjectType;
	}

	public List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds){
		List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
		if(!linkedEntityIds.isEmpty()){
			fflib_QueryFactory query = newQueryFactory()
				.setCondition('LinkedEntityId IN :linkedEntityIds')
				.setOrdering('ContentDocument.LatestPublishedVersion.CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING);
			contentDocumentLinks = Database.query(query.toSOQL());
		}
		return contentDocumentLinks;
	}

	public Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds){
		Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = new Map<Id, List<ContentDocumentLink>>();
		if(!contentDocumentIds.isEmpty()){
			for(ContentDocumentLink cdl : Database.query(newQueryFactory().setCondition('ContentDocumentId = :contentDocumentIds').toSOQL())){
				if(!contentDocumentLinksByContentDocumentId.containsKey(cdl.ContentDocumentId))
					contentDocumentLinksByContentDocumentId.put(cdl.ContentDocumentId, new List<ContentDocumentLink>());
				contentDocumentLinksByContentDocumentId.get(cdl.ContentDocumentId).add(cdl);
			}
		}
		return contentDocumentLinksByContentDocumentId;
	}
}