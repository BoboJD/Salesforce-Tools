@IsTest
private class StringUtilsTest{

	@IsTest
	static void convertNullToEmptyReturnEmpty(){
		Test.startTest();
		String theValueAfter = StringUtils.convertNullToEmpty(null);
		Test.stopTest();

		Assert.equals(Constants.EMPTY, theValueAfter);
	}

	@IsTest
	static void convertNullToEmptyReturnTheValue(){
		Test.startTest();
		String theValueAfter = StringUtils.convertNullToEmpty('Test');
		Test.stopTest();

		Assert.equals('Test', theValueAfter);
	}

	@IsTest
	static void formatNumberShouldReturnNumberAsStringFormat(){
		Test.startTest();
		String formattedNumber = StringUtils.formatNumber(1263.54);
		String formattedNumber2 = StringUtils.formatNumber(1);
		Test.stopTest();

		Assert.equals('1 263,54', formattedNumber);
		Assert.equals('1', formattedNumber2);
	}

	@IsTest
	static void formatNumberShouldReturnNull(){
		Test.startTest();
		String formattedNumber = StringUtils.formatNumber(null);
		Test.stopTest();

		Assert.isNull(formattedNumber);
	}

	@IsTest
	static void formatCurrencyShouldReturnNumberAsStringFormat(){
		Test.startTest();
		String formattedCurrency = StringUtils.formatCurrency(1263.54);
		Test.stopTest();

		Assert.equals('1 263,54 €', formattedCurrency);
	}

	@IsTest
	static void formatCurrencyShouldReturnNull(){
		Test.startTest();
		String formattedCurrency = StringUtils.formatCurrency(null);
		Test.stopTest();

		Assert.isNull(formattedCurrency);
	}

	@IsTest
	static void formatPercentShouldReturnNumberAsStringFormat(){
		Test.startTest();
		String formattedPercent = StringUtils.formatPercent(15.23);
		Test.stopTest();

		Assert.equals('15,23 %', formattedPercent);
	}

	@IsTest
	static void formatPercentShouldReturnNull(){
		Test.startTest();
		String formattedPercent = StringUtils.formatPercent(null);
		Test.stopTest();

		Assert.isNull(formattedPercent);
	}

	@IsTest
	static void isMobilePhoneWithPhoneNumberStartingWith06ShouldReturnTrue(){
		Assert.isTrue(StringUtils.isMobilePhone('0600000000'));
		Assert.isTrue(StringUtils.isMobilePhone('+33600000000'));
	}

	@IsTest
	static void isMobilePhoneWithPhoneNumberStartingWith07ShouldReturnTrue(){
		Assert.isTrue(StringUtils.isMobilePhone('0700000000'));
		Assert.isTrue(StringUtils.isMobilePhone('+33700000000'));
	}

	@IsTest
	static void isMobilePhoneWithPhoneNumberStartingWith05ShouldReturnFalse(){
		Assert.isFalse(StringUtils.isMobilePhone('0500000000'));
	}

	@IsTest
	static void setMobilePhoneInternationalShouldReturnNull(){
		Assert.isNull(StringUtils.setMobilePhoneInternational(''));
	}

	@IsTest
	static void setMobilePhoneInternationalShouldFormatMobilePhone(){
		Assert.equals('33700000000', StringUtils.setMobilePhoneInternational('+0700000000'));
		Assert.equals('33700000000', StringUtils.setMobilePhoneInternational('0700000000'));
		Assert.equals('33700000000', StringUtils.setMobilePhoneInternational('0033700000000'));
		Assert.equals('5000000000', StringUtils.setMobilePhoneInternational('5000000000'));
	}

	@IsTest
	static void containsAtLeastOneOfTheTermsWithEmptyTextShouldReturnFalse(){
		Assert.isFalse(StringUtils.containsAtLeastOneOfTheTerms('', new List<String>{'toto'}));
	}

	@IsTest
	static void containsAtLeastOneOfTheTermsWithEmptyListShouldReturnFalse(){
		Assert.isFalse(StringUtils.containsAtLeastOneOfTheTerms('toto', new List<String>{}));
	}

	@IsTest
	static void containsAtLeastOneOfTheTermsWithEmptyTermShouldReturnFalse(){
		Assert.isFalse(StringUtils.containsAtLeastOneOfTheTerms('toto', new List<String>{''}));
	}

	@IsTest
	static void containsAtLeastOneOfTheTermsWithTermFoundShouldReturnTrue(){
		Assert.isTrue(StringUtils.containsAtLeastOneOfTheTerms('toto', new List<String>{'ot'}));
	}

	@IsTest
	static void containsAtLeastOneOfTheTermsWithTermUnfoundShouldReturnFalse(){
		Assert.isFalse(StringUtils.containsAtLeastOneOfTheTerms('toto', new List<String>{'at'}));
	}
}