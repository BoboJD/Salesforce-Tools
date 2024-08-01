@IsTest
private class FeatureManagementServiceTest{

	@IsTest
	static void checkPermissionShouldNotReturnNull(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
		Test.stopTest();

		Assert.isNotNull(hasPermission);
	}

	@IsTest
	static void checkPermissionWithUnknownPermissionShouldReturnFalse(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.checkPermission('gjezogzjeog');
		Test.stopTest();

		Assert.isFalse(hasPermission);
	}
}