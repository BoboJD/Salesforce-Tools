@IsTest
private class UrlUtilsTest{

	@IsTest
	static void getSoapUrlShouldReturnUrl(){
		Assert.isNotNull(UrlUtils.getSoapUrl());
	}
}