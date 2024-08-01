@IsTest
private class EmailUtilsTest{

	@IsTest
	static void returnDomainWithAFullEmailAdress(){
		Test.startTest();
		String domain = EmailUtils.getDomain('test@gmail.com');
		Test.stopTest();

		Assert.equals('gmail.com', domain);
	}

	@IsTest
	static void returnBlankStringWithBlankParameter(){
		Test.startTest();
		String domain = EmailUtils.getDomain('');
		Test.stopTest();

		Assert.equals('', domain);
	}
}