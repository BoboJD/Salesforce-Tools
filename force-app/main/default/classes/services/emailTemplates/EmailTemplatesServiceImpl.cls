@SuppressWarnings('PMD.StdCyclomaticComplexity, PMD.NcssMethodCount, PMD.CognitiveComplexity, PMD.AvoidDeeplyNestedIfStmts')
public inherited sharing class EmailTemplatesServiceImpl implements IEmailTemplatesService{

	public String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
		if(String.isBlank(content)) return '';
		content = content.replaceAll('<!\\[CDATA\\[', '').replaceAll('\\]\\]>', '');
		for(SObject sObj : sObjects){
			DescribeSObjectResult sObjDescribe = sObj.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED);
			String objName = sObjDescribe.getName();
			for(SObjectField field : sObjDescribe.fields.getMap().values()){
				DescribeFieldResult describeFieldResult = field.getDescribe(FieldDescribeOptions.DEFAULT);
				String fieldName = describeFieldResult.getName();
				String fieldToReplace = '{!'+objName+'.'+fieldName+'}';
				if(content.contains(fieldToReplace)){
					DisplayType fieldDisplayType = describeFieldResult.getType();
					String fieldValue;
					if(isDecimal(fieldDisplayType)){
						fieldValue = StringUtils.formatNumber((Decimal)sObj.get(fieldName));
						if(fieldDisplayType == DisplayType.CURRENCY)
							fieldValue += ' €';
					}
					else if(fieldDisplayType == DisplayType.DATE)
						fieldValue = DateUtils.formatDate((Date)sObj.get(fieldName));
					else if(fieldDisplayType == DisplayType.PICKLIST)
						fieldValue = SObjectFieldUtils.getLabelOfPicklistValue(sObj, field);
					else
						fieldValue = (String)sObj.get(fieldName);
					if(fieldValue == null)
						fieldValue = '';
					content = content.replace(fieldToReplace, fieldValue);
				}
			}
			String linkField = '{!'+objName+'.Link}';
			if(content.contains(linkField)){
				String sfDomain = URL.getOrgDomainUrl().toExternalForm();
				content = content.replace(linkField, sfDomain+SObjectUtils.getRecordViewPage(sObj.Id));
			}
			String ownerFullNameField = '{!'+objName+'.OwnerFullName}';
			if(content.contains(ownerFullNameField))
				content = content.replace(ownerFullNameField, (String)sObj.getSobject('Owner').get('Name'));
		}
		return content;
	}

	private Boolean isDecimal(DisplayType fieldDisplayType){
		return fieldDisplayType == DisplayType.CURRENCY || fieldDisplayType == DisplayType.DOUBLE || fieldDisplayType == DisplayType.LONG;
	}
}