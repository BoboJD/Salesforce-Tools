@IsTest
private class SObjectUtilsTest{

	@IsTest
	static void getLabelShouldNotReturnNull(){
		Assert.isNotNull(SObjectUtils.getLabel(Log__c.SObjectType));
	}

	@IsTest
	static void getDeveloperNameShouldReturnLog(){
		Assert.equals('tlz__Log__c', SObjectUtils.getDeveloperName(Log__c.SObjectType));
	}

	@IsTest
	static void getRecordTypesShouldNotReturnEmptyList(){
		Test.startTest();
		List<RecordTypeInfo> recordTypes = SObjectUtils.getRecordTypes(Log__c.SObjectType);
		Test.stopTest();

		Assert.notEquals(0, recordTypes?.size());
	}

	@IsTest
	static void fieldValueHasChangedWithDifferentValueForSObjectFieldsShouldReturnTrue(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Tutu');
		Set<SObjectField> fieldsToVerify = new Set<SObjectField>{Schema.Account.Name};

		Test.startTest();
		Boolean fieldValueHasChanged = SObjectUtils.fieldValueHasChanged(accountAfter, accountBefore, fieldsToVerify);
		Test.stopTest();

		Assert.isTrue(fieldValueHasChanged);
	}

	@IsTest
	static void fieldValueHasChangedWithSameValueForSObjectFieldsShouldReturnFalse(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Toto');
		Set<SObjectField> fieldsToVerify = new Set<SObjectField>{Schema.Account.Name};

		Test.startTest();
		Boolean fieldValueHasChanged = SObjectUtils.fieldValueHasChanged(accountAfter, accountBefore, fieldsToVerify);
		Test.stopTest();

		Assert.isFalse(fieldValueHasChanged);
	}

	@IsTest
	static void fieldValueHasChangedWithNullParameterForSObjectFieldsShouldReturnFalse(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Tutu');
		Set<SObjectField> fieldsToVerify = new Set<SObjectField>{Schema.Account.Name};

		Test.startTest();
		Assert.isFalse(SObjectUtils.fieldValueHasChanged(null, accountBefore, fieldsToVerify));
		Assert.isFalse(SObjectUtils.fieldValueHasChanged(accountAfter, null, fieldsToVerify));
		Test.stopTest();
	}

	@IsTest
	static void fieldValueHasChangedWithDifferentValueForStringsShouldReturnTrue(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Tutu');
		Set<String> fieldsToVerify = new Set<String>{'Name'};

		Test.startTest();
		Boolean fieldValueHasChanged = SObjectUtils.fieldValueHasChanged(accountAfter, accountBefore, fieldsToVerify);
		Test.stopTest();

		Assert.isTrue(fieldValueHasChanged);
	}

	@IsTest
	static void fieldValueHasChangedWithSameValueForStringsShouldReturnFalse(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Toto');
		Set<String> fieldsToVerify = new Set<String>{'Name'};

		Test.startTest();
		Boolean fieldValueHasChanged = SObjectUtils.fieldValueHasChanged(accountAfter, accountBefore, fieldsToVerify);
		Test.stopTest();

		Assert.isFalse(fieldValueHasChanged);
	}

	@IsTest
	static void fieldValueHasChangedWithNullParameterForStringsShouldReturnFalse(){
		Account accountAfter = new Account(Name = 'Toto');
		Account accountBefore = new Account(Name = 'Tutu');
		Set<String> fieldsToVerify = new Set<String>{'Name'};

		Test.startTest();
		Assert.isFalse(SObjectUtils.fieldValueHasChanged(null, accountBefore, fieldsToVerify));
		Assert.isFalse(SObjectUtils.fieldValueHasChanged(accountAfter, null, fieldsToVerify));
		Test.stopTest();
	}

	@IsTest
	static void getCreatableFieldsShouldReturnSetThatContainsOnlyEditableFields(){
		Test.startTest();
		Set<String> opportunityFields = SObjectUtils.getCreatableFields(Schema.Opportunity.SObjectType);
		Test.stopTest();

		Assert.isTrue(opportunityFields.contains('Name'));
		Assert.isFalse(opportunityFields.contains('IsWon'));
	}

	@IsTest
	static void setReadableFieldsShouldFillReadonlyField(){
		Test.startTest();
		Opportunity opportunity = (Opportunity)SObjectUtils.setReadableFields(new Opportunity(), new Map<SObjectField, Object>{
			Schema.Opportunity.IsWon => true
		});
		Test.stopTest();

		Assert.isTrue(opportunity.IsWon);
	}

	@IsTest
	static void getRecordViewPageShouldReturnUrl(){
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

		Test.startTest();
		String url = SObjectUtils.getRecordViewPage(accountId);
		Test.stopTest();

		Assert.equals('/lightning/r/Account/'+accountId+'/view', url);
	}

	@IsTest
	static void getRecordViewPageShouldReturnNull(){
		Test.startTest();
		String url = SObjectUtils.getRecordViewPage(null);
		Test.stopTest();

		Assert.isNull(url);
	}

	@IsTest
	static void getExternalUrlShouldReturnUrl(){
		Id accountId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

		Test.startTest();
		String url = SObjectUtils.getExternalUrl(accountId);
		Test.stopTest();

		Assert.isTrue(url.contains('/lightning/r/Account/'+accountId+'/view'));
	}
}