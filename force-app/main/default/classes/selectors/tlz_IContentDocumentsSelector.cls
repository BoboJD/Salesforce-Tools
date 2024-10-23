global interface tlz_IContentDocumentsSelector extends fflib_ISObjectSelector{
	List<ContentDocument> selectByIds(Set<Id> contentDocumentIds);
}