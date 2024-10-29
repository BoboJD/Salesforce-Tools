@IsTest
private class SObjectFieldUtilsTest{

	@IsTest
	static void getLabelShouldNotReturnNull(){
		Assert.isNotNull(SObjectFieldUtils.getLabel(Schema.Account.Name));
	}

	@IsTest
	static void getValuesOfPicklistShouldReturnListOfString(){
		List<String> values = SObjectFieldUtils.getValuesOfPicklist(Schema.Opportunity.Type);
		Assert.notEquals(0, values.size());
	}

	@IsTest
	static void getPicklistValuesShouldReturnListOfDecoratedPicklistEntry(){
		List<DecoratedPicklistEntry> picklist = SObjectFieldUtils.getPicklistValues(Schema.Opportunity.Type);
		Assert.notEquals(0, picklist.size());
	}

	@IsTest
	static void getPicklistValuesWithNoneOptionShouldReturnListOfDecoratedPicklistEntry(){
		List<DecoratedPicklistEntry> picklist = SObjectFieldUtils.getPicklistValuesWithNoneOption(Schema.Opportunity.Type);
		Assert.notEquals(0, picklist.size());
	}

	@IsTest
	static void getDependentPicklistValuesShouldReturnMapOfDecoratedPicklistEntry(){
		Map<String, List<DecoratedPicklistEntry>> dependPicklist = SObjectFieldUtils.getDependentPicklistValues(Log__c.FormFactor__c);
		Assert.equals(1, dependPicklist.size());
		Assert.isTrue(dependPicklist.containsKey(LogConstants.TYPE_LNG_CMP));
		Assert.equals(3, dependPicklist.get(LogConstants.TYPE_LNG_CMP).size());
	}

	@IsTest
	static void getLabelOfPicklistValueShouldReturnLabelOfPicklistEntry(){
		Task task = new Task(
			Priority = 'High'
		);
		Assert.equals('High', SObjectFieldUtils.getLabelOfPicklistValue(task, Schema.Task.Priority));
		Assert.equals('High', SObjectFieldUtils.getLabelOfPicklistValue(Schema.Task.Priority, 'High'));
	}

	@IsTest
	static void getLabelOfPicklistValueShouldReturnNull(){
		Task task = new Task(
			Priority = null
		);
		Assert.isNull(SObjectFieldUtils.getLabelOfPicklistValue(task, Schema.Task.Priority));
	}

	@IsTest
	static void getFieldApiNameShouldReturnFieldApiName(){
		Assert.equals('Priority', SObjectFieldUtils.getFieldApiName(Schema.Task.Priority));
	}

	@IsTest
	static void multipicklistValuesShouldReturn2Values(){
		List<String> values = SObjectFieldUtils.multipicklistValues('A;B');
		Assert.equals(2, values?.size());
	}

	@IsTest
	static void multipicklistValuesShouldReturn0Values(){
		List<String> values = SObjectFieldUtils.multipicklistValues(null);
		Assert.equals(0, values?.size());
	}

	@IsTest
	static void orderedMultipicklistValuesShouldReturnSortedValues(){
		List<String> values = SObjectFieldUtils.orderedMultipicklistValues('2022;2021');
		Assert.equals(2, values?.size());
		Assert.equals('2021', values[0]);
		Assert.equals('2022', values[1]);
	}



	@IsTest
	static void multipicklistLabelsShouldReturn2Values(){
		Log__c log = new Log__c(
			FormFactor__c = 'Small;Medium'
		);
		List<String> labels = SObjectFieldUtils.multipicklistLabels(log, Log__c.FormFactor__c);
		Assert.equals(2, labels.size());
	}

	@IsTest
	static void multipicklistLabelsWithSeparatorShouldReturnConcatenedLabels(){
		Log__c log = new Log__c(
			FormFactor__c = 'Small;Medium'
		);
		String concatenedLabels = SObjectFieldUtils.multipicklistLabels(log, Log__c.FormFactor__c, ', ');
		String expectedConcatenation = SObjectFieldUtils.getLabelOfPicklistValue(Log__c.FormFactor__c, 'Small')
			+ ', ' + SObjectFieldUtils.getLabelOfPicklistValue(Log__c.FormFactor__c, 'Medium');
		Assert.equals(expectedConcatenation, concatenedLabels);
	}

	@IsTest
	static void getByApiNameShouldReturnSObjectField(){
		SObjectField sObjectField = SObjectFieldUtils.getByApiName(Schema.Account.SObjectType, 'Name');
		Assert.equals(Schema.Account.Name, sObjectField);
	}

	@IsTest
	static void syncFieldsShouldValueInFields(){
		Account account = new Account(Phone = '0556565656');
		Contact contact = new Contact();

		Map<SObjectField, SObjectField> targetFieldBySourceField = new Map<SObjectField, SObjectField>{
			Schema.Account.Phone => Schema.Contact.Phone
		};

		Test.startTest();
		SObjectFieldUtils.syncFields(contact, account, targetFieldBySourceField);
		Test.stopTest();

		Assert.equals('0556565656', contact.Phone);
	}

	@IsTest
	static void castTypeOfValueWithDecimalShouldReturnDecimal(){
		Test.startTest();
		Object returnedValue = SObjectFieldUtils.castTypeOfValue(Schema.Opportunity.Amount, 1.5);
		Test.stopTest();

		Assert.equals(1.5, returnedValue);
	}

	@IsTest
	static void castTypeOfValueWithBooleanShouldReturnBoolean(){
		Test.startTest();
		Object returnedValue = SObjectFieldUtils.castTypeOfValue(Schema.User.IsActive, true);
		Test.stopTest();

		Assert.isTrue(returnedValue);
	}

	@IsTest
	static void castTypeOfValueWithDateShouldReturnDate(){
		Test.startTest();
		Object returnedValue = SObjectFieldUtils.castTypeOfValue(Schema.Opportunity.CloseDate, '2024-10-21');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 10, 21), returnedValue);
	}

	@IsTest
	static void castTypeOfValueWithDatetimeShouldReturnDatetime(){
		Datetime now = System.now();
		String format = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';

		Test.startTest();
		Object returnedValue = SObjectFieldUtils.castTypeOfValue(Schema.Opportunity.CreatedDate, now.formatGmt(format));
		Test.stopTest();

		Assert.equals(now.formatGmt(format), ((Datetime)returnedValue).formatGmt(format));
	}

	@IsTest
	static void castTypeOfValueWithStringShouldReturnString(){
		Test.startTest();
		Object returnedValue = SObjectFieldUtils.castTypeOfValue(Schema.Opportunity.Name, 'Toto');
		Test.stopTest();

		Assert.equals('Toto', returnedValue);
	}
}