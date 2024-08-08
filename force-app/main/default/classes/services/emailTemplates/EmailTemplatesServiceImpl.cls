public inherited sharing class EmailTemplatesServiceImpl implements IEmailTemplatesService{

	public String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
		if(String.isBlank(content)) return '';
		content = removeCDataTags(content);
		for(SObject sObj : sObjects){
			String objName = sObj.getSObjectType().getDescribe().getName();
			content = replaceFieldReferences(content, sObj, objName);
			content = replaceSpecialPlaceholders(content, sObj, objName);
		}
		return content;
	}

	private String removeCDataTags(String content){
		return content.replaceAll('<!\\[CDATA\\[', '').replaceAll('\\]\\]>', '');
	}

	private String replaceFieldReferences(String content, SObject sObj, String objName){
		DescribeSObjectResult sObjDescribe = sObj.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED);
		for(SObjectField field : sObjDescribe.fields.getMap().values()){
			SObjectFieldWrapper fieldWrapper = new SObjectFieldWrapper(field, objName);
			if(content.contains(fieldWrapper.getFieldToReplace()))
				content = content.replace(fieldWrapper.getFieldToReplace(), fieldWrapper.getValue(sObj));
		}
		return content;
	}

	private String replaceSpecialPlaceholders(String content, SObject sObj, String objName){
		String sfDomain = URL.getOrgDomainUrl().toExternalForm();
		String linkField = '{!' + objName + '.Link}';
		if(content.contains(linkField))
			content = content.replace(linkField, sfDomain + SObjectUtils.getRecordViewPage(sObj.Id));
		String ownerFullNameField = '{!' + objName + '.OwnerFullName}';
		if(content.contains(ownerFullNameField)){
			String ownerFullName = (String)sObj.getSObject('Owner').get('Name');
			content = content.replace(ownerFullNameField, ownerFullName);
		}
		return content;
	}

	private class SObjectFieldWrapper{
		private final SObjectField sObjectField;
		private final String fieldToReplace;
		private final DisplayType fieldDisplayType;

		private SObjectFieldWrapper(SObjectField sObjectField, String objName){
			this.sObjectField = sObjectField;
			DescribeFieldResult describeFieldResult = sObjectField.getDescribe(FieldDescribeOptions.DEFAULT);
			this.fieldToReplace = '{!' + objName + '.' + describeFieldResult.getName() + '}';
			this.fieldDisplayType = describeFieldResult.getType();
		}

		private String getFieldToReplace(){
			return fieldToReplace;
		}

		private String getValue(SObject sObj){
			Object fieldValue = sObj.get(sObjectField);
			if(fieldValue == null)
				return '';
			if(isDecimal()){
				String formattedValue = StringUtils.formatNumber((Decimal)fieldValue);
				if(fieldDisplayType == DisplayType.CURRENCY)
					return formattedValue + ' €';
				return formattedValue;
			}
			if(fieldDisplayType == DisplayType.DATE)
				return DateUtils.formatDate((Date)fieldValue);
			if(fieldDisplayType == DisplayType.PICKLIST)
				return SObjectFieldUtils.getLabelOfPicklistValue(sObj, sObjectField);
			return String.valueOf(fieldValue);
		}

		private Boolean isDecimal(){
			return fieldDisplayType == DisplayType.CURRENCY || fieldDisplayType == DisplayType.DOUBLE || fieldDisplayType == DisplayType.LONG;
		}
	}
}