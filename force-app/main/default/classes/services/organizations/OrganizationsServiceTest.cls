@IsTest
private class OrganizationsServiceTest{

	@IsTest
	static void retrieveOrganizationNameWithOrgNotSandboxShouldReturnProd(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IOrganizationsSelector organizationsSelectorMock = new Mocks.tlz_OrganizationsSelector(mocks);

		Organization organization = (Organization)TestUtils.setReadableFields(new Organization(), new Map<SObjectField, Object>{
			Schema.Organization.IsSandbox => false
		});

		mocks.startStubbing();
		mocks.when(organizationsSelectorMock.sObjectType()).thenReturn(Schema.Organization.SObjectType);
		mocks.when(organizationsSelectorMock.selectAll()).thenReturn(new List<Organization>{organization});
		mocks.stopStubbing();

		Application.Selector.setMock(organizationsSelectorMock);

		Test.startTest();
		String organizationName = OrganizationsService.retrieveOrganizationName();
		Test.stopTest();

		((tlz_IOrganizationsSelector)mocks.verify(organizationsSelectorMock)).selectAll();

		Assert.equals(OrganizationConstants.PROD, organizationName);
	}

	@IsTest
	static void retrieveOrganizationNameWithSandboxShouldNotReturnProd(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IOrganizationsSelector organizationsSelectorMock = new Mocks.tlz_OrganizationsSelector(mocks);

		Organization organization = (Organization)TestUtils.setReadableFields(new Organization(), new Map<SObjectField, Object>{
			Schema.Organization.IsSandbox => true
		});

		mocks.startStubbing();
		mocks.when(organizationsSelectorMock.sObjectType()).thenReturn(Schema.Organization.SObjectType);
		mocks.when(organizationsSelectorMock.selectAll()).thenReturn(new List<Organization>{organization});
		mocks.stopStubbing();

		Application.Selector.setMock(organizationsSelectorMock);

		Test.startTest();
		String organizationName = OrganizationsService.retrieveOrganizationName();
		Test.stopTest();

		((tlz_IOrganizationsSelector)mocks.verify(organizationsSelectorMock)).selectAll();

		Assert.notEquals(OrganizationConstants.PROD, organizationName);
	}
}