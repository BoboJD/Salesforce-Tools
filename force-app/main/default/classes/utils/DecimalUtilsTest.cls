@IsTest
private class DecimalUtilsTest{

	@IsTest
	static void returnsZeroIfNullWithNullValueShouldReturnZero(){
		Test.startTest();
		Decimal theValue = DecimalUtils.returnsZeroIfNull(null);
		Test.stopTest();

		Assert.equals(0, theValue);
	}

	@IsTest
	static void returnsZeroIfNullWithValueShouldReturnTheValue(){
		Test.startTest();
		Decimal theValue = DecimalUtils.returnsZeroIfNull(1);
		Test.stopTest();

		Assert.equals(1, theValue);
	}

	@IsTest
	static void roundShouldReturnRoundedValue(){
		Assert.equals(2.67, DecimalUtils.round(2.666));
		Assert.equals(2, DecimalUtils.round(1.5, 0));
	}

	@IsTest
	static void roundDownShouldReturnRoundedValue(){
		Assert.equals(2.66, DecimalUtils.roundDown(2.666));
		Assert.equals(1.54, DecimalUtils.roundDown(1.548));
		Assert.equals(1, DecimalUtils.roundDown(1.548, 0));
	}

	@IsTest
	static void notGreaterThan0WithNullValueShouldReturnTrue(){
		Assert.isTrue(DecimalUtils.notGreaterThan0(null));
	}

	@IsTest
	static void notGreaterThan0WithZeroValueShouldReturnTrue(){
		Assert.isTrue(DecimalUtils.notGreaterThan0(0));
	}

	@IsTest
	static void notGreaterThan0WithValueShouldReturnFalse(){
		Assert.isFalse(DecimalUtils.notGreaterThan0(1));
	}

	@IsTest
	static void parseDecimalStringShouldReturnDecimal(){
		Assert.equals(20, DecimalUtils.parse('20 %'));
	}

	@IsTest
	static void parseBlankStringShouldReturnZero(){
		Assert.equals(0, DecimalUtils.parse(''));
	}
}