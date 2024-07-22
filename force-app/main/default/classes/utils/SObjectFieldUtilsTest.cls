@IsTest
private class SObjectFieldUtilsTest{

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
}