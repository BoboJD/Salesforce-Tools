@IsTest
private class TokenManagerTest{

	@IsTest
	static void tokenIsExpiredWithoutCachedTokenShouldReturnTrue(){
		Test.startTest();
		Boolean tokenIsExpired = TokenManager.tokenIsExpiredFor('Test');
		Test.stopTest();

		Assert.isTrue(tokenIsExpired);
	}

	@IsTest
	static void tokenIsExpiredWithCachedTokenShouldReturnFalse(){
		Cache.Org.getPartition('AccessToken').put('TestToken', 'token');

		Test.startTest();
		Boolean tokenIsExpired = TokenManager.tokenIsExpiredFor('Test');
		Test.stopTest();

		Assert.isFalse(tokenIsExpired);
	}

	@IsTest
	static void setTokenShouldCacheTheTokenInTheOrg(){
		String accessToken = 'tokenToCache';

		Test.startTest();
		TokenManager.setToken('Test', accessToken);
		Test.stopTest();

		Assert.equals(accessToken, (String)Cache.Org.getPartition('AccessToken').get('TestToken'));
		Assert.equals(accessToken, TokenManager.getInstance().tokenByService.get('Test'));
	}

	@IsTest
	static void getTokenShouldReturnCachedTokenInTheOrg(){
		String accessToken = 'tokenToCache';
		Cache.Org.getPartition('AccessToken').put('TestToken', accessToken);

		Test.startTest();
		String returnedAccessToken = TokenManager.getToken('Test');
		Test.stopTest();

		Assert.equals(accessToken, returnedAccessToken);
	}

	@IsTest
	static void getTokenShouldReturnTokenInTheMap(){
		String accessToken = 'tokenToCache';
		TokenManager.getInstance().tokenByService.put('Test', accessToken);

		Test.startTest();
		String returnedAccessToken = TokenManager.getToken('Test');
		Test.stopTest();

		Assert.equals(accessToken, returnedAccessToken);
	}

	@IsTest
	static void resetTokenShouldReturnRemoveTokenFromCache(){
		String accessToken = 'tokenToCache';
		Cache.Org.getPartition('AccessToken').put('TestToken', accessToken);

		Test.startTest();
		TokenManager.resetToken('Test');
		String returnedAccessToken = TokenManager.getToken('Test');
		Test.stopTest();

		Assert.isNull(returnedAccessToken);
	}
}