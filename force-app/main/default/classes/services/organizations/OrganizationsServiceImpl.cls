global inherited sharing class OrganizationsServiceImpl implements IOrganizationsService{
	private static String organizationName;
	private static String organizationCountryCode;
	private static Boolean isProductionOrg;

	global Boolean isProduction(){
		if(isProductionOrg == null){
			List<Organization> orgs = tlz_OrganizationsSelector.newInstance().selectAll();
			isProductionOrg = !orgs.isEmpty() && !orgs[0].IsSandbox;
		}
		return isProductionOrg;
	}

	global String retrieveOrganizationName(){
		if(organizationName == null){
			if(isProduction()){
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