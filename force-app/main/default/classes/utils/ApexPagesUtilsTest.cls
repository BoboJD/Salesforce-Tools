@IsTest
private class ApexPagesUtilsTest{

	@IsTest
	static void extractSetIdsParameterFromUrlWithCommaSeparatedStringShouldReturnSetIds(){
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);
		Id contactId = fflib_IDGenerator.generate(Schema.Contact.SObjectType);
		String parameter = 'myParameter';
		String concatenation = accountId + ',' + contactId;
		ApexPages.currentPage().getParameters().put(parameter, concatenation);

		Test.startTest();
		Set<Id> ids = ApexPagesUtils.extractSetIdsParameterFromUrl(parameter);
		Test.stopTest();

		Set<Id> expectedIds = new Set<Id>{accountId, contactId};
		Assert.equals(expectedIds, ids);
	}

	@IsTest
	static void extractSetIdsParameterFromUrlWithNullStringShouldReturnEmptySetIds(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, null);

		Test.startTest();
		Set<Id> ids = ApexPagesUtils.extractSetIdsParameterFromUrl(parameter);
		Test.stopTest();

		Set<Id> expectedIds = new Set<Id>();
		Assert.equals(expectedIds, ids);
	}

	@IsTest
	static void extractDateParameterFromUrlWithFormattedDateStringShouldReturnDate(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, '2021-09-14');

		Test.startTest();
		Date returnedDate = ApexPagesUtils.extractDateParameterFromUrl(parameter);
		Test.stopTest();

		Assert.equals(Date.newInstance(2021, 9, 14), returnedDate);
	}

	@IsTest
	static void extractDateParameterFromUrlWithNullStringShouldReturnNullDate(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, null);

		Test.startTest();
		Date returnedDate = ApexPagesUtils.extractDateParameterFromUrl(parameter);
		Test.stopTest();

		Assert.isNull(returnedDate);
	}

	@IsTest
	static void extractStringParameterFromUrlShouldReturnString(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, 'param');

		Test.startTest();
		String returnedString = ApexPagesUtils.extractStringParameterFromUrl(parameter);
		Test.stopTest();

		Assert.equals('param', returnedString);
	}

	@IsTest
	static void extractBooleanParameterFromUrlWithNullValueShouldReturnFalse(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, null);

		Test.startTest();
		Boolean returnedBoolean = ApexPagesUtils.extractBooleanParameterFromUrl(parameter);
		Test.stopTest();

		Assert.isFalse(returnedBoolean);
	}

	@IsTest
	static void extractBooleanParameterFromUrlWithTrueValueShouldReturnTrue(){
		String parameter = 'myParameter';
		ApexPages.currentPage().getParameters().put(parameter, 'tRuE');

		Test.startTest();
		Boolean returnedBoolean = ApexPagesUtils.extractBooleanParameterFromUrl(parameter);
		Test.stopTest();

		Assert.isTrue(returnedBoolean);
	}
}