@IsTest
private class EmailUtilsTest{

	@IsTest
	static void returnDomainWithAFullEmailAdress(){
		Test.startTest();
		String domain = EmailUtils.getDomain('test@moncourtierenergie.com');
		Test.stopTest();

		Assert.equals('moncourtierenergie.com', domain);
	}

	@IsTest
	static void returnBlankStringWithBlankParameter(){
		Test.startTest();
		String domain = EmailUtils.getDomain('');
		Test.stopTest();

		Assert.equals('', domain);
	}
}