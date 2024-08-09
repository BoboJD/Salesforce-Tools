global inherited sharing class EmailTemplatesService{

	global static String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
		return service().replaceFieldReferencesByValue(content, sObjects);
	}

	private static IEmailTemplatesService service(){
		return (IEmailTemplatesService)Application.Service.newInstance(IEmailTemplatesService.class);
	}
}