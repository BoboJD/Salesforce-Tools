global with sharing class LookupController{

	@AuraEnabled
	global static List<DecoratedPicklistEntry> search(String criteriaJSON){
		List<DecoratedPicklistEntry> searchResults = new List<DecoratedPicklistEntry>();
		Criteria criteria = (Criteria)JSON.deserialize(criteriaJSON, Criteria.class);
		for(SObject sObj : Database.query(criteria.toSOQL())){
			DecoratedPicklistEntry searchResult = DecoratedPicklistEntry.newInstance((String)sObj.get(criteria.valueFieldApiName), (String)sObj.get(criteria.mainFieldDisplayed));
			if(String.isNotBlank(criteria.additionalFieldsDisplayed))
				searchResult.description = concatAdditionalFieldsValue(sObj, criteria);
			for(String otherField : criteria.otherFields)
				mapValueByAttribute(searchResult.fields, sObj, otherField);
			searchResults.add(searchResult);
		}
		return searchResults;
	}

	private static String concatAdditionalFieldsValue(SObject sObj, Criteria criteria){
		String description = '';
		for(String additionalFieldDisplayed : criteria.additionalFieldsDisplayed.split(',')){
			Object fieldValue = getSObjectValue(sObj, additionalFieldDisplayed);
			if(fieldValue != null)
				description += fieldValue + ' • ';
		}
		return description.removeEnd(' • ');
	}

	@TestVisible
	private static Object getSObjectValue(SObject sObj, String fieldName){
		if(isCrossReferenceField(fieldName)){
			List<String> fieldNameSplitted = fieldName.split('\\.');
			return getSObjectValue(sObj?.getSObject(fieldNameSplitted[0]), fieldNameSplitted[1]);
		}
		return sObj?.get(fieldName);
	}

	private static Boolean isCrossReferenceField(String fieldName){
		return fieldName.contains('.');
	}

	@TestVisible
	private static void mapValueByAttribute(Map<String, Object> valueByAttribute, SObject sObj, String fieldName){
		if(isCrossReferenceField(fieldName))
			mapCrossReferenceValueByAttribute(valueByAttribute, sObj, fieldName);
		else
			valueByAttribute.put(fieldName, sObj?.get(fieldName));
	}

	private static void mapCrossReferenceValueByAttribute(Map<String, Object> valueByAttribute, SObject sObj, String fieldName){
		List<String> fieldNameSplitted = fieldName.split('\\.');
		String crossReferenceField = fieldNameSplitted[0];
		SObject crossReferenceSObject = sObj.getSObject(crossReferenceField);
		if(!valueByAttribute.containsKey(crossReferenceField))
			valueByAttribute.put(crossReferenceField, new Map<String, Object>());
		mapValueByAttribute((Map<String, Object>)valueByAttribute.get(crossReferenceField), crossReferenceSObject, fieldNameSplitted[1]);
	}

	global class Criteria{
		global String sObjectApiName;
		global String searchFieldApiName;
		global String searchedTerm;
		global Integer nbResultMax;
		global String valueFieldApiName;
		global String mainFieldDisplayed;
		global String additionalFieldsDisplayed;
		global String additionalFields;
		global String additionalSearchFieldsApiName;
		global String additionalCondition;

		private Set<String> otherFields{
			get{
				Set<String> otherFields = new Set<String>();
				if(String.isNotBlank(additionalFieldsDisplayed))
					otherFields.addAll(additionalFieldsDisplayed.split(','));
				if(String.isNotBlank(additionalFields))
					otherFields.addAll(additionalFields.split(','));
				return otherFields;
			}set;
		}

		private String escapedSearchedTerm{
			get{
				return String.escapeSingleQuotes(searchedTerm).replaceAll(' ', '%');
			}
		}

		@TestVisible
		private Criteria(){}

		private String toSOQL(){
			String soql = 'SELECT '+valueFieldApiName+','+mainFieldDisplayed;
			for(String otherField : otherFields)
				soql += ','+otherField;
			soql += ' FROM '+sObjectApiName+
				' WHERE ('+searchFieldApiName+' LIKE \''+escapedSearchedTerm+'%\'';
			if(String.isNotBlank(additionalSearchFieldsApiName)){
				for(String additionalSearchFieldApiName : additionalSearchFieldsApiName.split(','))
					soql += ' OR '+additionalSearchFieldApiName+' LIKE \''+escapedSearchedTerm+'%\'';
			}
			soql += ' )';
			if(String.isNotBlank(additionalCondition))
				soql += ' '+additionalCondition;
			soql += ' ORDER BY '+mainFieldDisplayed+' ASC'
				+ ' LIMIT '+nbResultMax;
			return soql;
		}
	}
}