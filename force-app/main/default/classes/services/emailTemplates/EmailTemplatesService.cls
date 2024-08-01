public inherited sharing class EmailTemplatesService{

	public static String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
		return service().replaceFieldReferencesByValue(content, sObjects);
	}

	private static IEmailTemplatesService service(){
		return (IEmailTemplatesService)Application.Service.newInstance(IEmailTemplatesService.class);
	}
}