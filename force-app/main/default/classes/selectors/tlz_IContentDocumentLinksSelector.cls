global interface tlz_IContentDocumentLinksSelector extends fflib_ISObjectSelector{
	List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds);
	List<ContentDocumentLink> selectByLinkedEntityIdsAndFileTypes(Set<Id> linkedEntityIds, List<String> fileTypes);
	Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds);
}