@IsTest
private class AuthorizationUtilTest{
	private static final SObjectType TEST_OBJECT_TYPE = Opportunity.SObjectType;

	@TestSetup
	static void setup(){
		UserBuilder.newChatterFreeUser().build();
	}

	private static void verifyCheckMethods(Boolean authorized){
		Assert.equals(authorized, AuthorizationUtil.isAccessible(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtil.isCreateable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtil.isUpdateable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtil.isUpsertable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtil.isDeletable(TEST_OBJECT_TYPE));
		Assert.equals(authorized, AuthorizationUtil.isUndeletable(TEST_OBJECT_TYPE));
	}

	private static void verifyAssertMethods(Boolean authorized){
		try{
			AuthorizationUtil.assertAccessible(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtil.assertCreateable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtil.assertUpdateable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtil.assertUpsertable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtil.assertDeletable(TEST_OBJECT_TYPE);
			Assert.isTrue(authorized);
		}catch(Exception e){
			Assert.isFalse(authorized);
		}
		try{
			AuthorizationUtil.assertUndeletable(TEST_OBJECT_TYPE);
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