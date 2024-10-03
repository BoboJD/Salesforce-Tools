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

	@IsTest
	static void bypassChatterNotificationShouldNotReturnNull(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.bypassChatterNotification();
		Test.stopTest();

		Assert.isNotNull(hasPermission);
	}

	@IsTest
	static void bypassValidationRulesShouldNotReturnNull(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.bypassValidationRules();
		Test.stopTest();

		Assert.isNotNull(hasPermission);
	}
}