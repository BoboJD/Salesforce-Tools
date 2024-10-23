global interface tlz_IContentDocumentLinksSelector extends fflib_ISObjectSelector{
	List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds);
	Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds);
}