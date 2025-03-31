global class DecoratedPicklistEntry{
	@AuraEnabled global String value {get;set;}
	@AuraEnabled global String label {get;set;}
	@AuraEnabled global String description {get;set;}
	@AuraEnabled global Map<String, Object> fields {get;set;}
	@AuraEnabled global String validFor {get;set;}
	@AuraEnabled global Boolean checked {get;set;}

	global DecoratedPicklistEntry(){
		fields = new Map<String, Object>();
		checked = false;
	}

	global DecoratedPicklistEntry(String value, String label){
		this();
		this.value = value;
		this.label = label;
	}

	global static DecoratedPicklistEntry newInstance(String valueLabel){
		return new DecoratedPicklistEntry(valueLabel, valueLabel);
	}

	global static DecoratedPicklistEntry newInstance(String value, String label){
		return new DecoratedPicklistEntry(value, label);
	}

	global static DecoratedPicklistEntry newInstance(Schema.RecordTypeInfo recordType){
		DecoratedPicklistEntry picklistEntry = new DecoratedPicklistEntry(recordType.getRecordTypeId(), recordType.getName());
		picklistEntry.fields.put('developerName', recordType.getDeveloperName());
		return picklistEntry;
	}

	global static DecoratedPicklistEntry newInstanceFromSObject(SObject record){
		return new DecoratedPicklistEntry(record.Id, (String)record.get('Name'));
	}

	global static DecoratedPicklistEntry newInstanceFromSObject(Contact contact){
		String label = contact.Salutation + ' ' + contact.Name;
		return new DecoratedPicklistEntry(contact.Id, label);
	}

	global static DecoratedPicklistEntry newInstanceFromPicklistEntry(Schema.PicklistEntry entry){
		return new DecoratedPicklistEntry(entry.getValue(), entry.getLabel());
	}

	global static DecoratedPicklistEntry newInstanceFromPicklist(Sobject record, SObjectField sObjectField){
		String label = SObjectFieldUtils.getLabelOfPicklistValue(record, sObjectField);
		return new DecoratedPicklistEntry((String)record.get(sObjectField), label);
	}

	global static DecoratedPicklistEntry newNoneOption(){
		return new DecoratedPicklistEntry(Constants.EMPTY, Constants.NONE);
	}

	global DecoratedPicklistEntry setFieldValue(SObject record, List<SObjectField> sObjectFields){
		for(SObjectField sObjectField : sObjectFields)
			setFieldValue(record, sObjectField);
		return this;
	}

	global DecoratedPicklistEntry setFieldValue(SObject record, SObjectField sObjectField){
		fields.put(sObjectField.getDescribe(FieldDescribeOptions.DEFAULT).getName(), record.get(sObjectField));
		return this;
	}

	global DecoratedPicklistEntry addDescription(List<String> terms){
		for(String term : terms)
			addDescription(term);
		return this;
	}

	global DecoratedPicklistEntry addDescription(String term){
		if(String.isNotBlank(term)){
			if(String.isBlank(description))
				this.description = term;
			else
				this.description += ' • ' + term;
		}
		return this;
	}
}