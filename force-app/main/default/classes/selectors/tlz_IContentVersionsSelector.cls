global interface tlz_IContentVersionsSelector extends fflib_ISObjectSelector{
	List<ContentVersion> selectLatestByContentDocumentIds(Set<Id> contentDocumentIds);
}