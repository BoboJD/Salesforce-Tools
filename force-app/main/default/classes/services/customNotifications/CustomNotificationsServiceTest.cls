@IsTest
private class CustomNotificationsServiceTest{

	@IsTest
	static void testNotifyUsersShouldNotThrowError(){
		Test.startTest();
		CustomNotificationsService.notifyUsers(null, new Set<String>{}, 'title', 'body');
		Test.stopTest();

		Assert.isNotNull(CustomNotificationsServiceImpl.notification);
	}

	@IsTest
	static void testNotifyUserShouldNotThrowError(){
		Test.startTest();
		CustomNotificationsService.notifyUser(UserInfo.getUserId(), 'title', 'body');
		Test.stopTest();

		Assert.isNotNull(CustomNotificationsServiceImpl.notification);
	}
}