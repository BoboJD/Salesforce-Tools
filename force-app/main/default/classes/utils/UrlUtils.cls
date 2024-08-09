global inherited sharing class UrlUtils{

	global static String getSoapUrl(){
		return URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/u/' + Constants.LATEST_SALESFORCE_VERSION + '/' + UserInfo.getOrganizationId();
	}
}