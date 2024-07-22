@IsTest
private class IntegerUtilsTest{

	@IsTest
	static void returnsZeroIfNullWithNullValueShouldReturnZero(){
		Test.startTest();
		Integer theValue = IntegerUtils.returnsZeroIfNull(null);
		Test.stopTest();

		Assert.equals(0, theValue);
	}

	@IsTest
	static void returnsZeroIfNullWithValueShouldReturnTheValue(){
		Test.startTest();
		Integer theValue = IntegerUtils.returnsZeroIfNull(1);
		Test.stopTest();

		Assert.equals(1, theValue);
	}
}