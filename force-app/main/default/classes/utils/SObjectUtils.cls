public inherited sharing class SObjectUtils{

	public static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, Set<SObjectField> fieldsToVerify){
		return fieldValueHasChanged(sObjectAfter, sObjectBefore, new List<SObjectField>(fieldsToVerify));
	}

	public static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, List<SObjectField> fieldsToVerify){
		if(sObjectAfter == null || sObjectBefore == null || fieldsToVerify == null || fieldsToVerify.isEmpty())
			return false;
		for(SObjectField sObjectfield : fieldsToVerify)
			if(sObjectAfter.get(sObjectfield) != sObjectBefore.get(sObjectfield))
				return true;
		return false;
	}

	public static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, Set<String> fieldsToVerify){
		return fieldValueHasChanged(sObjectAfter, sObjectBefore, new List<String>(fieldsToVerify));
	}

	public static Boolean fieldValueHasChanged(SObject sObjectAfter, SObject sObjectBefore, List<String> fieldsToVerify){
		if(sObjectAfter == null || sObjectBefore == null || fieldsToVerify == null || fieldsToVerify.isEmpty())
			return false;
		for(String sObjectfield : fieldsToVerify)
			if(sObjectAfter.get(sObjectfield) != sObjectBefore.get(sObjectfield))
				return true;
		return false;
	}

	public static Set<String> getCreatableFields(SObjectType objType){
		Set<String> fields = new Set<String>();
		Map<String, SObjectField> fMap = objType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap();
		if(fMap != null){
			for(SObjectField ft : fMap.values()){
				DescribeFieldResult fd = ft.getDescribe(FieldDescribeOptions.DEFAULT);
				if(fd.isCreateable())
					fields.add(fd.getName());
			}
		}
		return fields;
	}

	public static SObject setReadableFields(SObject sObj, Map<SObjectField, Object> valueBysObjField){
		Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
		for(SObjectField field : valueBysObjField.keySet()){
			String fieldName = field.getDescribe(FieldDescribeOptions.DEFAULT).getName();
			dataMap.put(fieldName, valueBysObjField.get(field));
		}
		return (SObject)JSON.deserialize(JSON.serialize(dataMap), SObject.class);
	}

	public static String getRecordViewPage(Id recordId){
		return recordId != null ? '/lightning/r/'+recordId.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED).getName()+'/'+recordId+'/view' : null;
	}

	public static String getExternalUrl(Id recordId){
		return URL.getOrgDomainUrl().toExternalForm() + getRecordViewPage(recordId);
	}
}