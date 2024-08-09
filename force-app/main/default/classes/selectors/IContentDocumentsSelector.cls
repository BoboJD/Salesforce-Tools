global interface IContentDocumentsSelector extends fflib_ISObjectSelector{
	List<ContentDocument> selectByIds(Set<Id> contentDocumentIds);
}