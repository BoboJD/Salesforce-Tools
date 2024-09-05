@IsTest
private class OrgSettingsTest{

	@IsTest
	static void getSettingShouldReturnFieldValue(){
		Assert.equals('https://www.test.com', OrgSettings.get(OrgSetting__mdt.TestUrl__c));
		Assert.equals('zkyfeRRoodkyjbxYGf15Nvw5FEH3D/FcSLygJDydbZA=', OrgSettings.get(OrgSetting__mdt.TestPassword__c));
	}

	@IsTest
	static void getCryptedValueWithRealDataShouldDecryptValue(){
		insert new EncryptionKey__c(Value__c = 'xLNSoRbaMiEVrCOppUkj2ITiyTIWRmJuxpcBT2VR5+0=');
		Test.startTest();
		String password = OrgSettings.decrypt(OrgSetting__mdt.TestPassword__c);
		Test.stopTest();
		Assert.equals('FakePassword', password);
	}

	@IsTest
	static void getCryptedValueForUnitTestShouldReturnFakePassword(){
		Test.startTest();
		String password = OrgSettings.decrypt(OrgSetting__mdt.TestPassword__c);
		Test.stopTest();
		Assert.equals('FakePasswordFromException', password);
	}

	@IsTest
	static void getSettingsWithoutMetadataRecordShouldThrowError(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveOrganizationName()).thenReturn('ABCD');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		Test.startTest();
		String errorMessage;
		try{
			OrgSettings.get(OrgSetting__mdt.TestUrl__c);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveOrganizationName();

		Assert.equals('OrgSettings metadata record missing for org ABCD', errorMessage);
	}
}