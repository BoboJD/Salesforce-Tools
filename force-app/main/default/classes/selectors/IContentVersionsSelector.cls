global interface IContentVersionsSelector extends fflib_ISObjectSelector{
	List<ContentVersion> selectLatestByContentDocumentIds(Set<Id> contentDocumentIds);
}