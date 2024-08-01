@SuppressWarnings('PMD.CognitiveComplexity')
public inherited sharing class SObjectFieldUtils{

	private static final String BASE64MAP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	public static List<String> getValuesOfPicklist(SObjectField field){
		List<String> values = new List<String>();
		for(Schema.PicklistEntry entry : field.getDescribe(FieldDescribeOptions.DEFAULT).getPicklistValues())
			if(entry.isActive()) values.add(entry.getValue());
		return values;
	}

	public static List<DecoratedPicklistEntry> getPicklistValues(SObjectField field){
		List<DecoratedPicklistEntry> picklistEntries = new List<DecoratedPicklistEntry>();
		for(Schema.PicklistEntry entry : field.getDescribe(FieldDescribeOptions.DEFAULT).getPicklistValues())
			if(entry.isActive()) picklistEntries.add(DecoratedPicklistEntry.newInstanceFromPicklistEntry(entry));
		return picklistEntries;
	}

	public static List<DecoratedPicklistEntry> getPicklistValuesWithNoneOption(SObjectField field){
		List<DecoratedPicklistEntry> picklistEntries = new List<DecoratedPicklistEntry>{ DecoratedPicklistEntry.newNoneOption() };
		picklistEntries.addAll(getPicklistValues(field));
		return picklistEntries;
	}

	public static Map<String, List<DecoratedPicklistEntry>> getDependentPicklistValues(Schema.sObjectField dependPicklist){
		List<Schema.PicklistEntry> controlEntries = dependPicklist.getDescribe(FieldDescribeOptions.DEFAULT).getController().getDescribe(FieldDescribeOptions.DEFAULT).getPicklistValues();
		Map<String,List<DecoratedPicklistEntry>> dependentPicklistValues = new Map<String,List<DecoratedPicklistEntry>>();
		for(Schema.PicklistEntry entry : dependPicklist.getDescribe(FieldDescribeOptions.DEFAULT).getPicklistValues()){
			if(entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))){
				List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
				for(Integer index = 0; index < controlEntries.size(); index++){
					Object controlValue = (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null);
					Integer bitIndex = index / 6;
					if(bitIndex > base64chars.size() - 1) break;
					Integer bitShift = 5 - Math.mod(index, 6);
					if(controlValue == null || (BASE64MAP.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0)
						continue;
					if(!dependentPicklistValues.containsKey((String)controlValue))
						dependentPicklistValues.put((String)controlValue, new List<DecoratedPicklistEntry>());
					dependentPicklistValues.get((String)controlValue).add(DecoratedPicklistEntry.newInstanceFromPicklistEntry(entry));
				}
			}
		}
		return dependentPicklistValues;
	}

	public static String getLabelOfPicklistValue(SObject sObj, SObjectField field){
		String value = (String)sObj.get(field.getDescribe().getName());
		return getLabelOfPicklistValue(field, value);
	}

	public static String getLabelOfPicklistValue(SObjectField field, String value){
		String label = value;
		if(String.isNotBlank(value)){
			for(Schema.PicklistEntry ple : field.getDescribe().getPicklistValues()){
				if(ple.getValue() == value){
					label = ple.getLabel();
					break;
				}
			}
		}
		return label;
	}

	public static String getFieldApiName(SObjectField field){
		return field.getDescribe().getName();
	}

	public static List<String> multipicklistValues(String concatenedValues){
		return String.isBlank(concatenedValues) ? new List<String>() : concatenedValues.split(';');
	}

	public static List<String> orderedMultipicklistValues(String concatenedValues){
		List<String> values = multipicklistValues(concatenedValues);
		values.sort();
		return values;
	}

	public static List<String> multipicklistLabels(SObject sObj, SObjectField field){
		List<String> labels = new List<String>();
		String concatenedValues = (String)sObj?.get(field);
		if(String.isNotBlank(concatenedValues)){
			for(String value : concatenedValues.split(';'))
				labels.add(getLabelOfPicklistValue(field, value));
		}
		return labels;
	}

	public static String multipicklistLabels(SObject sObj, SObjectField field, String separator){
		return String.join(multipicklistLabels(sObj, field), separator);
	}

	public static SObjectField getByApiName(SObjectType sObjectType, String apiName){
		return Schema.getGlobalDescribe().get(sObjectType.getDescribe().getName()).getDescribe().fields.getMap().get(apiName);
	}

	public static void syncFields(SObject targetSObject, SObject sourceSObject, Map<SObjectField, SObjectField> targetFieldBySourceField){
		for(SObjectField sourceField : targetFieldBySourceField.keySet()){
			SObjectField targetField = targetFieldBySourceField.get(sourceField);
			targetSObject.put(targetField, sourceSObject.get(sourceField));
		}
	}
}