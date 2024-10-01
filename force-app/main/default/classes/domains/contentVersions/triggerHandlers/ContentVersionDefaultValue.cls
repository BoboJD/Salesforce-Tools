global with sharing class ContentVersionDefaultValue extends ContentVersionsHandler{

	private ContentVersionDefaultValue(tlz_ContentVersions domain){
		super(domain);
	}

	global static ContentVersionDefaultValue handleInsert(tlz_ContentVersions domain){
		return new ContentVersionDefaultValue(domain);
	}

	global void setDefaultFieldValueBasedOnJSON(){
		for(ContentVersion contentVersion : contentVersions){
			if(String.isNotBlank(contentVersion.JSON_fileupload__c))
				setFieldsValueFromJSON(contentVersion);
		}
	}

	private void setFieldsValueFromJSON(ContentVersion contentVersion){
		Map<String, Object> jsonFields = (Map<String, Object>)JSON.deserializeUntyped(contentVersion.JSON_fileupload__c);
		for(String fieldName : jsonFields.keySet()){
			if(jsonFields.get(fieldName) != null)
				contentVersion.put(fieldName, jsonFields.get(fieldName));
		}
	}
}