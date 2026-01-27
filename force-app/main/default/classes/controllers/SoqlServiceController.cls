global with sharing class SoqlServiceController{

	@AuraEnabled
	global static Map<String, Object> query(String queryString){
		Map<String, Object> result = new Map<String, Object>();
		try{
			List<SObject> records = Database.query(queryString);
			result = ControllerUtils.success('records', records);
		}catch(Exception e){
			LogFactory.commitError(SoqlServiceController.class, 'query', new List<Object>{ queryString }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}

	@AuraEnabled
	global static Map<String, Object> countQuery(String queryString){
		Map<String, Object> result = new Map<String, Object>();
		try{
			Integer count = Database.countQuery(queryString);
			result = ControllerUtils.success('count', count);
		}catch(Exception e){
			LogFactory.commitError(SoqlServiceController.class, 'countQuery', new List<Object>{ queryString }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}

	@AuraEnabled(cacheable=true)
	global static List<Map<String, String>> getSObjectList(){
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
		List<String> sObjectNames = new List<String>(globalDescribe.keySet());
		sObjectNames.sort();

		List<Map<String, String>> sObjectList = new List<Map<String, String>>();
		for(String sObjectName : sObjectNames){
			Schema.DescribeSObjectResult describe = globalDescribe.get(sObjectName).getDescribe(SObjectDescribeOptions.DEFERRED);
			if(describe.isAccessible() && describe.isQueryable()){
				sObjectList.add(new Map<String, String>{
					'apiName' => describe.getName(),
					'label' => describe.getLabel(),
					'labelPlural' => describe.getLabelPlural()
				});
			}
		}
		return sObjectList;
	}

	@AuraEnabled(cacheable=true)
	global static List<Map<String, Object>> getFieldsForSObject(String sObjectApiName){
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectApiName);
		if(sObjectType == null){
			throw new AuraHandledException('SObject not found: ' + sObjectApiName);
		}
		List<Map<String, Object>> fieldList = new List<Map<String, Object>>();
		Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap();
		for(String fieldName : fieldMap.keySet()){
			Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
			if(fieldDescribe.isAccessible()){
				fieldList.add(new Map<String, Object>{
					'apiName' => fieldDescribe.getName(),
					'label' => fieldDescribe.getLabel(),
					'type' => String.valueOf(fieldDescribe.getType()),
					'isFilterable' => fieldDescribe.isFilterable(),
					'isSortable' => fieldDescribe.isSortable(),
					'isNameField' => fieldDescribe.isNameField()
				});
			}
		}
		return fieldList;
	}
}
