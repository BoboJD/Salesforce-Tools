@IsTest
private class SetUtilsTest{

	@IsTest
	static void transformListStringToSetIdShouldReturnOneId(){
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

		Test.startTest();
		Set<Id> accountIds = SetUtils.transformListStringToSetId(new List<String>{accountId});
		Test.stopTest();

		Assert.equals(new Set<Id>{accountId}, accountIds);
	}

	@IsTest
	static void hasStringsWithEmptyOrNullSetShouldReturnFalse(){
		Set<String> terms = new Set<String>();
		Assert.isFalse(SetUtils.hasStrings(null));
		Assert.isFalse(SetUtils.hasStrings(terms));
	}

	@IsTest
	static void hasStringsWithEmptyStringInSetShouldReturnFalse(){
		Set<String> terms = new Set<String>{''};
		Assert.isFalse(SetUtils.hasStrings(terms));
	}

	@IsTest
	static void hasStringsWithStringInSetShouldReturnTrue(){
		Set<String> terms = new Set<String>{'toto'};
		Assert.isTrue(SetUtils.hasStrings(terms));
	}
}