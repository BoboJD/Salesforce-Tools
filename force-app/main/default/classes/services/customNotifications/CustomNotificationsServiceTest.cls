@IsTest
private class CustomNotificationsServiceTest{

	@IsTest
	static void testNotifyUsersShouldNotThrowError(){
		Test.startTest();
		CustomNotificationsService.notifyUsers(null, new Set<String>{}, 'title', 'body');
		Test.stopTest();

		Assert.isNotNull(CustomNotificationsServiceImpl.notification);
	}
}