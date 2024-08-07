@IsTest
private class OrgSettingsTest{

	@IsTest
	static void getSettingsShouldReturnFieldValueForEachSetting(){
		for(OrgSettings.Setting setting : OrgSettings.Setting.values())
			OrgSettings.get(setting);
	}

	@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
	@IsTest(SeeAllData=true)
	static void getCryptedValueWithRealDataShouldDecryptValue(){
		Test.startTest();
		String password = OrgSettings.get(OrgSettings.Setting.TEST_PASSWORD);
		Test.stopTest();
		Assert.equals('FakePassword', password);
	}

	@IsTest
	static void getCryptedValueForUnitTestShouldReturnFakePassword(){
		Test.startTest();
		String password = OrgSettings.get(OrgSettings.Setting.TEST_PASSWORD);
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
			for(Integer i = 0 ; i < OrgSettings.Setting.values().size() ; i++)
				OrgSettings.get(OrgSettings.Setting.values()[i]);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveOrganizationName();

		Assert.equals('OrgSettings metadata record missing for org ABCD', errorMessage);
	}
}