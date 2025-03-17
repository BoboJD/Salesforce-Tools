@SuppressWarnings('PMD.CognitiveComplexity')
global inherited sharing class SObjectUtils{

	global static String getLabel(SObjectType sObjType){
		return sObjType.getDescribe(SObjectDescribeOptions.DEFERRED).getLabel();
	}

	global static String getLabelPlural(SObjectType sObjType){
		return sObjType.getDescribe(SObjectDescribeOptions.DEFERRED).getLabelPlural();
	}

	global static String getDeveloperName(SObjectType sObjType){
		return sObjType.getDescribe(SObjectDescribeOptions.DEFERRED).getName();
	}

	global static List<RecordTypeInfo> getRecordTypes(SObjectType sObjType){
		return sObjType.getDescribe(SObjectDescribeOptions.DEFERRED).getRecordTypeInfos();
	}

	global static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, Set<SObjectField> fieldsToVerify){
		return fieldValueHasChanged(sObjectAfter, sObjectBefore, new List<SObjectField>(fieldsToVerify));
	}

	global static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, List<SObjectField> fieldsToVerify){
		if(sObjectAfter == null || sObjectBefore == null || fieldsToVerify == null || fieldsToVerify.isEmpty())
			return false;
		for(SObjectField sObjectfield : fieldsToVerify)
			if(sObjectAfter.get(sObjectfield) != sObjectBefore.get(sObjectfield))
				return true;
		return false;
	}

	global static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, Set<String> fieldsToVerify){
		return fieldValueHasChanged(sObjectAfter, sObjectBefore, new List<String>(fieldsToVerify));
	}

	global static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, List<String> fieldsToVerify){
		if(sObjectAfter == null || sObjectBefore == null || fieldsToVerify == null || fieldsToVerify.isEmpty())
			return false;
		for(String sObjectfield : fieldsToVerify)
			if(sObjectAfter.get(sObjectfield) != sObjectBefore.get(sObjectfield))
				return true;
		return false;
	}

	global static Set<String> getCreatableFields(SObjectType objType){
		Set<String> fields = new Set<String>();
		Map<String, SObjectField> fMap = objType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap();
		for(SObjectField ft : fMap.values()){
			DescribeFieldResult fd = ft.getDescribe(FieldDescribeOptions.DEFAULT);
			if(fd.isCreateable())
				fields.add(fd.getName());
		}
		return fields;
	}

	global static SObject setReadableFields(SObject sObj, Map<SObjectField, Object> valueBysObjField){
		Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
		for(SObjectField field : valueBysObjField.keySet()){
			String fieldName = field.getDescribe(FieldDescribeOptions.DEFAULT).getName();
			dataMap.put(fieldName, valueBysObjField.get(field));
		}
		return (SObject)JSON.deserialize(JSON.serialize(dataMap), SObject.class);
	}

	global static String getRecordViewPage(Id recordId){
		return recordId != null ? '/lightning/r/'+recordId.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED).getName()+'/'+recordId+'/view' : null;
	}

	global static String getExternalUrl(Id recordId){
		return URL.getOrgDomainUrl().toExternalForm() + getRecordViewPage(recordId);
	}
}