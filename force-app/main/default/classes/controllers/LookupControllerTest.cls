@IsTest
private class LookupControllerTest{

	@IsTest
	static void getSObjectValueShouldReturnFieldValue(){
		Account account = new Account(Name = 'Test');
		Assert.equals(account.Name, LookupController.getSObjectValue(account, 'Name'));
	}

	@IsTest
	static void getSObjectValueWithCrossReferenceFieldShouldReturnCrossReferenceFieldValue(){
		Account parentAccount = new Account(Name = 'Test');
		Account account = (Account)TestUtils.setReadableFields(new Account(), new Map<String, Object>{
			'Parent' => parentAccount
		});
		Assert.equals(parentAccount.Name, LookupController.getSObjectValue(account, 'Parent.Name'));
	}

	@IsTest
	static void getSObjectValueShouldReturnNoFieldValue(){
		Account account = new Account();
		Assert.isNull(LookupController.getSObjectValue(account, 'Name'));
	}

	@IsTest
	static void getSObjectValueShouldReturnNoCrossReferenceFieldValue(){
		Account account = (Account)TestUtils.setReadableFields(new Account(), new Map<String, Object>{
			'Parent' => null
		});
		Assert.isNull(LookupController.getSObjectValue(account, 'Parent.Name'));
	}

	@IsTest
	static void mapValueByAttributeShouldReturnFieldValue(){
		Account account = new Account(Name = 'Test', BillingCity = 'Bordeaux');
		Map<String, Object> valueByAttr = new Map<String, Object>();
		LookupController.mapValueByAttribute(valueByAttr, account, 'Name');
		LookupController.mapValueByAttribute(valueByAttr, account, 'BillingCity');
		Assert.equals(account.Name, valueByAttr.get('Name'));
		Assert.equals(account.BillingCity, valueByAttr.get('BillingCity'));
	}

	@IsTest
	static void mapValueByAttributeWithCrossReferenceFieldShouldReturnCrossReferenceFieldValue(){
		Account parentAccount = new Account(Name = 'Test', BillingCity = 'Bordeaux');
		Account account = (Account)TestUtils.setReadableFields(new Account(), new Map<String, Object>{
			'Parent' => parentAccount
		});
		Map<String, Object> valueByAttr = new Map<String, Object>();
		LookupController.mapValueByAttribute(valueByAttr, account, 'Parent.Name');
		LookupController.mapValueByAttribute(valueByAttr, account, 'Parent.BillingCity');
		Map<String, Object> crossReferenceValueByAttr = (Map<String, Object>)valueByAttr.get('Parent');
		Assert.equals(parentAccount.Name, crossReferenceValueByAttr.get('Name'));
		Assert.equals(parentAccount.BillingCity, crossReferenceValueByAttr.get('BillingCity'));
	}

	@IsTest
	static void mapValueByAttributeShouldReturnNoFieldValue(){
		Account account = new Account();
		Map<String, Object> valueByAttr = new Map<String, Object>();
		LookupController.mapValueByAttribute(valueByAttr, account, 'Name');
		Assert.isNull(valueByAttr.get('Name'));
	}

	@IsTest
	static void mapValueByAttributeWithCrossReferenceObjectNullShouldReturnCrossReferenceFieldValueAsNull(){
		Account account = (Account)TestUtils.setReadableFields(new Account(), new Map<String, Object>{
			'Parent' => null
		});
		Map<String, Object> valueByAttr = new Map<String, Object>();
		LookupController.mapValueByAttribute(valueByAttr, account, 'Parent.Name');
		Map<String, Object> crossReferenceValueByAttr = (Map<String, Object>)valueByAttr.get('Parent');
		Assert.isNull(crossReferenceValueByAttr.get('Name'));
	}

	@IsTest
	static void searchUserWithExistingRecordShouldReturnOneRow(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser) {
			LookupController.Criteria criteria = new LookupController.Criteria();
			criteria.sObjectApiName = 'User';
			criteria.searchFieldApiName = 'Name';
			criteria.searchedTerm = 'Standard User';
			criteria.nbResultMax = 5;
			criteria.valueFieldApiName = 'Id';
			criteria.mainFieldDisplayed = 'Name';
			criteria.additionalFieldsDisplayed = 'Phone';
			criteria.additionalFields = 'Email';
			criteria.additionalSearchFieldsApiName = 'FirstName';
			criteria.additionalCondition = 'AND Name != NULL';

			Test.startTest();
			List<DecoratedPicklistEntry> result = LookupController.search(JSON.serialize(criteria));
			Test.stopTest();

			Assert.equals(1, result.size());
			Assert.equals(standardUser.Id, result[0].value);
			Assert.equals('Standard User', result[0].label);
		}
	}
}