@IsTest
private class AuthorizationUtilsTest{
	private static final SObjectType TEST_OBJECT_TYPE = Opportunity.SObjectType;

	@TestSetup
	static void setup(){
		UserBuilder.newChatterFreeUser().build();
	}

	private static void verifyCheckMethods(Boolean authorized){
		Assert.equals(authorized, AuthorizationUtils.isAccessible(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtils.isCreateable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtils.isUpdateable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtils.isUpsertable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtils.isDeletable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtils.isUndeletable(TEST_OBJECT_TYPE));
	}

	private static void verifyAssertMethods(Boolean authorized){
		try{
			AuthorizationUtils.assertAccessible(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtils.assertCreateable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtils.assertUpdateable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtils.assertUpsertable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtils.assertDeletable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtils.assertUndeletable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
	}

	@IsTest
	static void testAuthorizedUser(){
		verifyCheckMethods(true);
		verifyAssertMethods(true);
	}

	@IsTest
	static void testUnauthorizedUser(){
		User unuauthorizedUser = TestUtils.selectChatterFreeUser();
		System.runAs(unuauthorizedUser){
			verifyCheckMethods(false);
			verifyAssertMethods(false);
		}
	}
}