@IsTest
private class UrlUtilsTest{

	@IsTest
	static void getSoapUrlShouldReturnUrl(){
		Assert.isNotNull(UrlUtils.getSoapUrl());
	}

	@IsTest
	static void replaceParameterValueShouldChangeParameterValue(){
		Assert.equals('https://test.fr?a=c', UrlUtils.replaceParameterValue('https://test.fr?a=b', 'a', 'c'));
		Assert.equals('https://test.fr?a=b&c=g&e=f', UrlUtils.replaceParameterValue('https://test.fr?a=b&c=d&e=f', 'c', 'g'));
		Assert.equals('https://test.fr?a=b&c=d&e=f&g=h', UrlUtils.replaceParameterValue('https://test.fr?a=b&c=d&e=f', 'g', 'h'));
		Assert.equals('a=c', UrlUtils.replaceParameterValue('a=b', 'a', 'c'));
		Assert.equals('a=b&c=g&e=f', UrlUtils.replaceParameterValue('a=b&c=d&e=f', 'c', 'g'));
		Assert.equals('a=b&c=d&e=f&g=h', UrlUtils.replaceParameterValue('a=b&c=d&e=f', 'g', 'h'));
		Assert.equals('', UrlUtils.replaceParameterValue('', 'a', 'c'));
		Assert.equals('a=b', UrlUtils.replaceParameterValue('a=b', '', 'c'));
	}
}