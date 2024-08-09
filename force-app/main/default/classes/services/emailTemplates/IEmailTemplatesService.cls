global interface IEmailTemplatesService{
	String replaceFieldReferencesByValue(String content, List<SObject> sObjects);
}