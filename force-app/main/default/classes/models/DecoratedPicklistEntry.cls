public class DecoratedPicklistEntry{
	@AuraEnabled public String value {get;set;}
	@AuraEnabled public String label {get;set;}
	@AuraEnabled public String description {get;set;}
	@AuraEnabled public Map<String, Object> fields {get;set;}
	@AuraEnabled public String validFor {get;set;}
	@AuraEnabled public Boolean checked {get;set;}

	private DecoratedPicklistEntry(){
		fields = new Map<String, Object>();
		checked = false;
	}

	private DecoratedPicklistEntry(String value, String label){
		this();
		this.value = value;
		this.label = label;
	}

	public static DecoratedPicklistEntry newInstance(String valueLabel){
		return new DecoratedPicklistEntry(valueLabel, valueLabel);
	}

	public static DecoratedPicklistEntry newInstance(String value, String label){
		return new DecoratedPicklistEntry(value, label);
	}

	public static DecoratedPicklistEntry newInstanceFromSObject(SObject record){
		return new DecoratedPicklistEntry(record.Id, (String)record.get('Name'));
	}

	public static DecoratedPicklistEntry newInstanceFromSObject(Contact contact){
		String label = contact.Salutation + ' ' + contact.Name;
		return new DecoratedPicklistEntry(contact.Id, label);
	}

	public static DecoratedPicklistEntry newInstanceFromPicklistEntry(Schema.PicklistEntry entry){
		return new DecoratedPicklistEntry(entry.getValue(), entry.getLabel());
	}

	public static DecoratedPicklistEntry newInstanceFromPicklist(Sobject record, SObjectField sObjectField){
		String label = SObjectFieldUtils.getLabelOfPicklistValue(record, sObjectField);
		return new DecoratedPicklistEntry((String)record.get(sObjectField), label);
	}

	public static DecoratedPicklistEntry newNoneOption(){
		return new DecoratedPicklistEntry(Constants.EMPTY, Constants.NONE);
	}

	public DecoratedPicklistEntry setFieldValue(SObject record, List<SObjectField> sObjectFields){
		for(SObjectField sObjectField : sObjectFields)
			setFieldValue(record, sObjectField);
		return this;
	}

	public DecoratedPicklistEntry setFieldValue(SObject record, SObjectField sObjectField){
		fields.put(sObjectField.getDescribe(FieldDescribeOptions.DEFAULT).getName(), record.get(sObjectField));
		return this;
	}

	public DecoratedPicklistEntry addDescription(List<String> terms){
		for(String term : terms)
			addDescription(term);
		return this;
	}

	public DecoratedPicklistEntry addDescription(String term){
		if(String.isNotBlank(term)){
			if(String.isBlank(description))
				this.description = term;
			else
				this.description += ' • ' + term;
		}
		return this;
	}
}