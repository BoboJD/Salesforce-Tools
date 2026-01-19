global inherited sharing class OrganizationsService{

	global static String retrieveOrganizationName(){
		return service().retrieveOrganizationName();
	}

	global static String retrieveCountryCode(){
		return service().retrieveCountryCode();
	}

	private static IOrganizationsService service(){
		return (IOrganizationsService)Application.Service.newInstance(IOrganizationsService.class);
	}
}