public inherited sharing class OrganizationsService{

	public static String retrieveOrganizationName(){
		return service().retrieveOrganizationName();
	}

	private static IOrganizationsService service(){
		return (IOrganizationsService)Application.Service.newInstance(IOrganizationsService.class);
	}
}