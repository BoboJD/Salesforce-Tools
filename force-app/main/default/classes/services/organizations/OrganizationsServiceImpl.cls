global inherited sharing class OrganizationsServiceImpl implements IOrganizationsService{
	private static String organizationName;

	global String retrieveOrganizationName(){
		if(organizationName == null){
			List<Organization> orgs = OrganizationsSelector.newInstance().selectAll();
			if(!orgs.isEmpty() && !orgs[0].IsSandbox){
				organizationName = OrganizationConstants.PROD;
			}else{
				String orgName = System.Url.getOrgDomainUrl().getHost();
				organizationName = orgName.containsIgnoreCase(OrganizationConstants.PREPROD) ? OrganizationConstants.PREPROD : OrganizationConstants.DEV;
			}
		}
		return organizationName;
	}
}