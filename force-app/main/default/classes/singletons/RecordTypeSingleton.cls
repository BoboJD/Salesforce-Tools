global class RecordTypeSingleton{
	private static RecordTypeSingleton instance;
	global Map<String, Map<String, Schema.RecordTypeInfo>> recordTypeByObjAndDeveloperName {get;private set;}

	private RecordTypeSingleton(){
		recordTypeByObjAndDeveloperName = new Map<String, Map<String, Schema.RecordTypeInfo>>();
	}

	private static RecordTypeSingleton getInstance(){
		if(instance == null) instance = new RecordTypeSingleton();
		return instance;
	}

	global static Schema.RecordTypeInfo getRecordTypeInfo(SObjectType obj, String recordTypeDeveloperName){
		String objName = obj.getDescribe(SObjectDescribeOptions.DEFERRED).getName();
		if(!getInstance().recordTypeByObjAndDeveloperName.containsKey(objName))
			setRecordTypesForSObject(obj);
		Map<String, Schema.RecordTypeInfo> recordTypeByDevName = getInstance().recordTypeByObjAndDeveloperName.get(objName);
		return recordTypeByDevName.containsKey(recordTypeDeveloperName) ? recordTypeByDevName.get(recordTypeDeveloperName) : null;
	}

	private static void setRecordTypesForSObject(SObjectType obj){
		DescribeSObjectResult objDescribe = obj.getDescribe(SObjectDescribeOptions.DEFERRED);
		getInstance().recordTypeByObjAndDeveloperName.put(objDescribe.getName(), objDescribe.getRecordTypeInfosByDeveloperName());
	}

	global static Id getRecordTypeId(SObjectType obj, String recordTypeDeveloperName){
		Schema.RecordTypeInfo recordTypeInfo = getRecordTypeInfo(obj, recordTypeDeveloperName);
		return recordTypeInfo != null ? recordTypeInfo.getRecordTypeId() : null;
	}
}