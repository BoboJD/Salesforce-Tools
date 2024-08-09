@SuppressWarnings('PMD.ApexCRUDViolation')
global inherited sharing abstract class SObjectBuilder{
	private Map<String, Object> valueByFieldName;
	private Map<SObjectField, Object> valueBySObjectField;

	global SObjectBuilder(){
		valueByFieldName = new Map<String, Object>();
		valueBySObjectField = new Map<SObjectField, Object>();
	}

	global SObjectBuilder(String recordTypeDeveloperName){
		this();
		withRecordType(recordTypeDeveloperName);
	}

	abstract SObjectType getSObjectType();

	private SObjectBuilder withRecordType(String recordTypeDeveloperName){
		setFieldValue('RecordTypeId', RecordTypeSingleton.getRecordTypeId(getSObjectType(), recordTypeDeveloperName));
		return this;
	}

	global SObjectBuilder setFieldValue(SObjectField sObjectField, Object value){
		valueBySObjectField.put(sObjectField, value);
		return this;
	}

	global SObjectBuilder setFieldValue(String fieldName, Object value){
		valueByFieldName.put(fieldName, value);
		return this;
	}

	global SObject buildRecord(){
		return buildRecord(true);
	}

	global SObject buildRecordWithoutCommit(){
		return buildRecord(false);
	}

	private SObject buildRecord(Boolean commitData){
		SObject record = getSObjectType().newSObject();
		for(String fieldName : valueByFieldName.keySet())
			record.put(fieldName, valueByFieldName.get(fieldName));
		for(SObjectField sObjectField : valueBySObjectField.keySet())
			record.put(sObjectField, valueBySObjectField.get(sObjectField));
		if(commitData && AuthorizationUtil.isCreateable(getSObjectType()))
			insert record;
		return record;
	}

	global static List<SObject> build(List<SObjectBuilder> sObjectBuilders){
		List<SObject> records = new List<SObject>();
		for(SObjectBuilder sObjectBuilder : sObjectBuilders){
			if(AuthorizationUtil.isCreateable(sObjectBuilder.getSObjectType()))
				records.add(sObjectBuilder.buildRecordWithoutCommit());
		}
		insert records;
		return records;
	}

	global static Map<String, SObject> buildRecords(Map<String, SObjectBuilder> sObjectBuilders){
		Map<String, SObject> records = new Map<String, SObject>();
		for(String friendlyName : sObjectBuilders.keySet()){
			SObjectBuilder sObjectBuilder = sObjectBuilders.get(friendlyName);
			if(AuthorizationUtil.isCreateable(sObjectBuilder.getSObjectType()))
				records.put(friendlyName, sObjectBuilder.buildRecordWithoutCommit());
		}
		insert records.values();
		return records;
	}
}