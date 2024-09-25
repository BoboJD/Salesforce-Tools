@IsTest
private class DecoratedPicklistEntryTest{

	@IsTest
	static void testsForInstanciationAndMethods(){
		DecoratedPicklistEntry picklistEntry = DecoratedPicklistEntry.newInstance('label');
		Assert.equals('label', picklistEntry.value);
		Assert.equals('label', picklistEntry.label);

		picklistEntry = DecoratedPicklistEntry.newInstance('value', 'label');
		Assert.equals('value', picklistEntry.value);
		Assert.equals('label', picklistEntry.label);

		List<RecordTypeInfo> recordTypes = SObjectUtils.getRecordTypes(Log__c.SObjectType);
		picklistEntry = DecoratedPicklistEntry.newInstance(recordTypes[0]);
		Assert.equals(recordTypes[0].getRecordTypeId(), picklistEntry.value);
		Assert.equals(recordTypes[0].getName(), picklistEntry.label);
		Assert.equals(recordTypes[0].getDeveloperName(), picklistEntry.fields?.get('developerName'));

		Account account = new Account(
			Id = fflib_IDGenerator.generate(Schema.Account.SObjectType),
			Name = 'toto'
		);
		picklistEntry = DecoratedPicklistEntry.newInstanceFromSObject(account);
		Assert.equals(account.Id, picklistEntry.value);
		Assert.equals(account.Name, picklistEntry.label);

		Contact contact = (Contact)TestUtils.setReadableFields(new Contact(
			Id = fflib_IDGenerator.generate(Schema.Contact.SObjectType),
			Salutation = 'Mr.'
		), new Map<String, Object>{
			'Name' => 'Tutu'
		});
		picklistEntry = DecoratedPicklistEntry.newInstanceFromSObject(contact);
		Assert.equals(contact.Id, picklistEntry.value);
		Assert.equals('Mr. Tutu', picklistEntry.label);

		List<DecoratedPicklistEntry> picklistEntries = new List<DecoratedPicklistEntry>();
		for(Schema.PicklistEntry entry : Log__c.Type__c.getDescribe(FieldDescribeOptions.DEFAULT).getPicklistValues())
			picklistEntries.add(DecoratedPicklistEntry.newInstanceFromPicklistEntry(entry));
		Assert.isFalse(picklistEntries.isEmpty());

		Log__c log = new Log__c(
			Type__c = LogConstants.TYPE_APEX,
			Message__c = 'message'
		);
		picklistEntry = DecoratedPicklistEntry.newInstanceFromPicklist(log, Log__c.Type__c)
			.setFieldValue(log, new List<SObjectField>{ Log__c.Message__c })
			.addDescription(new List<String>{'toto', 'tutu'});
		Assert.equals(LogConstants.TYPE_APEX, picklistEntry.value);
		Assert.equals(LogConstants.TYPE_APEX, picklistEntry.label);
		Assert.equals('message', picklistEntry.fields.get('tlz__Message__c'));
		Assert.equals('toto • tutu', picklistEntry.description);

		picklistEntry = DecoratedPicklistEntry.newNoneOption();
		Assert.equals(Constants.EMPTY, picklistEntry.value);
		Assert.equals(Constants.NONE, picklistEntry.label);
	}
}