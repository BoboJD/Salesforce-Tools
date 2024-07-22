public inherited sharing class UrlUtils{

	public static String getSoapUrl(){
		return URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/u/' + Constants.LATEST_SALESFORCE_VERSION + '/' + UserInfo.getOrganizationId();
	}
}