global inherited sharing class tlz_CustomNotificationTypesSelector extends fflib_SObjectSelector implements tlz_ICustomNotificationTypesSelector{

	private static Map<String, CustomNotificationType> recordByDeveloperName;

	global static tlz_ICustomNotificationTypesSelector newInstance(){
		return (tlz_ICustomNotificationTypesSelector)Application.Selector.newInstance(CustomNotificationType.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			CustomNotificationType.Id,
			CustomNotificationType.DeveloperName
		};
	}

	global override SObjectType getSObjectType(){
		return CustomNotificationType.SObjectType;
	}

	global CustomNotificationType selectByDeveloperName(String developerName){
		if(recordByDeveloperName == null){
			recordByDeveloperName = new Map<String, CustomNotificationType>();
			for(CustomNotificationType customNotificationType : Database.query(newQueryFactory(false, false, true).setLimit(50000).toSOQL()))
				recordByDeveloperName.put(customNotificationType.DeveloperName, customNotificationType);
		}
		return recordByDeveloperName.get(developerName);
	}
}