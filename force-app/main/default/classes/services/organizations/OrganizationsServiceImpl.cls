global inherited sharing class OrganizationsServiceImpl implements IOrganizationsService{
	private static String organizationName;
	private static String organizationCountryCode;

	global String retrieveOrganizationName(){
		if(organizationName == null){
			List<Organization> orgs = tlz_OrganizationsSelector.newInstance().selectAll();
			if(!orgs.isEmpty() && !orgs[0].IsSandbox){
				organizationName = OrganizationConstants.PROD;
			}else{
				String orgName = System.Url.getOrgDomainUrl().getHost();
				organizationName = orgName.containsIgnoreCase(OrganizationConstants.PREPROD) ? OrganizationConstants.PREPROD : OrganizationConstants.DEV;
			}
		}
		return organizationName;
	}

	global String retrieveCountryCode(){
		if(organizationCountryCode == null){
			List<Organization> orgs = tlz_OrganizationsSelector.newInstance().selectAll();
			organizationCountryCode = orgs.isEmpty() ? '' : orgs[0].Country;
		}
		return organizationCountryCode;
	}
}