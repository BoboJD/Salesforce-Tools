private void insertOrgWideEmailAddress(){
	HttpRequest request = new HttpRequest();
	request.setEndpoint(System.Url.getOrgDomainUrl().toExternalForm() + '/services/Soap/c/62.0/' + UserInfo.getOrganizationId());
	request.setMethod('POST');
	request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	request.setHeader('SOAPAction', '""');
	request.setTimeout(120000);
	request.setBody(insertSObjectXmlBody());
	new Http().send(request);
}

private String insertSObjectXmlBody(){
	return '<?xml version="1.0" encoding="utf-8"?>'
		+ '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'
		+ '		xmlns:urn="urn:enterprise.soap.sforce.com"'
		+ '		xmlns:urn1="urn:sobject.enterprise.soap.sforce.com"'
		+ '		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
		+ '	<soapenv:Header>'
		+ '		<urn:SessionHeader>'
		+ '			<urn:sessionId>' + UserInfo.getSessionId() + '</urn:sessionId>'
		+ '		</urn:SessionHeader>'
		+ '	</soapenv:Header>'
		+ '	<soapenv:Body>'
		+ '		<urn:create>'
		+ '			<urn:sObjects xsi:type="urn1:OrgWideEmailAddress">'
		+ ' 			<DisplayName>IT Team</DisplayName>'
		+ ' 			<IsAllowAllProfiles>true</IsAllowAllProfiles>'
		+ ' 			<Purpose>UserSelection</Purpose>'
		+ ' 			<Address>' + UserInfo.getUserEmail() + '</Address>'
		+ '			</urn:sObjects>'
		+ '		</urn:create>'
		+ '	</soapenv:Body>'
		+ '</soapenv:Envelope>';
}

insertOrgWideEmailAddress();