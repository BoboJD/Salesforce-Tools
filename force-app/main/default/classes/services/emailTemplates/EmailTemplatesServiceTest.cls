@IsTest
private class EmailTemplatesServiceTest{

	@IsTest
	static void replaceFieldReferencesByValueShouldReplaceEveryFieldOccurenceInEmailTemplate(){
		Account account = new Account(
			Name = 'Toto',
			AnnualRevenue = 2
		);

		String content = 'Compte - {!Account.Name} {!Account.Name} {!Account.Name} <![CDATA[{!Account.AnnualRevenue}]]>';

		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(content, new List<SObject>{account});
		Test.stopTest();

		Assert.equals('Compte - Toto Toto Toto 2 €', contentAfter);
	}

	@IsTest
	static void replaceFieldReferencesByValueShouldReplacePicklistValueByPicklistLabel(){
		Task task = new Task(
			Priority = 'High'
		);

		String content = '{!Task.Priority}';

		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(content, new List<SObject>{task});
		Test.stopTest();

		String expectedLabel = SObjectFieldUtils.getLabelOfPicklistValue(task, Schema.Task.Priority);
		Assert.equals(expectedLabel, contentAfter);
	}

	@IsTest
	static void replaceFieldReferencesByValueShouldFormatDateFields(){
		Task task = new Task(
			ActivityDate = Date.today()
		);

		String content = '{!Task.ActivityDate}';

		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(content, new List<SObject>{task});
		Test.stopTest();

		String expectedFormat = DateUtils.formatDate(Date.today());
		Assert.equals(expectedFormat, contentAfter);
	}

	@IsTest
	static void replaceFieldReferencesByValueShouldReplaceLink(){
		Account account = new Account(
			Id = fflib_IDGenerator.generate(Schema.Account.SObjectType)
		);

		String content = 'Link : {!Account.Link}';

		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(content, new List<SObject>{account});
		Test.stopTest();

		Assert.isTrue(contentAfter.contains(SObjectUtils.getRecordViewPage(account.Id)));
	}

	@IsTest
	static void replaceFieldReferencesByValueShouldReplaceOwnerFullName(){
		User user = (User)TestUtils.setReadableFields(new User(), new Map<SObjectField, Object>{
			Schema.User.Name => 'Toto'
		});
		Account account = (Account)TestUtils.setReadableFields(new Account(
			Id = fflib_IDGenerator.generate(Schema.Account.SObjectType)
		), new Map<String, Object>{
			'Owner' => user
		});

		String content = 'Owner : {!Account.OwnerFullName}';

		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(content, new List<SObject>{account});
		Test.stopTest();

		Assert.equals('Owner : Toto', contentAfter);
	}

	@IsTest
	static void replaceFieldReferencesByValueShouldReturnEmptyString(){
		Test.startTest();
		String contentAfter = EmailTemplatesService.replaceFieldReferencesByValue(null, new List<SObject>{});
		Test.stopTest();

		Assert.equals('', contentAfter);
	}
}