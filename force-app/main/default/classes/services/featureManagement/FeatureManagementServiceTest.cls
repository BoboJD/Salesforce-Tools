@IsTest
private class FeatureManagementServiceTest{

	@IsTest
	static void checkPermissionShouldReturnFalse(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Test.startTest();
			Boolean hasPermission = FeatureManagementService.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
			Test.stopTest();

			Assert.isFalse(hasPermission);
		}
	}

	@IsTest
	static void checkPermissionWithPermissionSetAssignedShouldReturnTrue(){
		User standardUser = UserBuilder.newStandardUser().build();
		TestUtils.assignPermission(standardUser, PermissionConstants.BYPASS_CHATTER_NOTIFICATION.removeStart('tlz__'));
		System.runAs(standardUser){
			Test.startTest();
			Boolean hasPermission = FeatureManagementService.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
			Test.stopTest();

			Assert.isTrue(hasPermission);
		}
	}

	@IsTest
	static void checkPermissionWithUnknownPermissionShouldReturnFalse(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.checkPermission('gjezogzjeog');
		Test.stopTest();

		Assert.isFalse(hasPermission);
	}

	@IsTest
	static void bypassChatterNotificationShouldReturnFalse(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.bypassChatterNotification();
		Test.stopTest();

		Assert.isFalse(hasPermission);
	}

	@IsTest
	static void bypassValidationRulesShouldReturnFalse(){
		Test.startTest();
		Boolean hasPermission = FeatureManagementService.bypassValidationRules();
		Test.stopTest();

		Assert.isFalse(hasPermission);
	}
}