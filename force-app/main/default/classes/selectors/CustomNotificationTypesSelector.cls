public inherited sharing class CustomNotificationTypesSelector extends fflib_SObjectSelector implements ICustomNotificationTypesSelector{

	private static Map<String, CustomNotificationType> recordByDeveloperName;

	public static ICustomNotificationTypesSelector newInstance(){
		return (ICustomNotificationTypesSelector)Application.Selector.newInstance(CustomNotificationType.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			CustomNotificationType.Id,
			CustomNotificationType.DeveloperName
		};
	}

	public SObjectType getSObjectType(){
		return CustomNotificationType.SObjectType;
	}

	public CustomNotificationType selectByDeveloperName(String developerName){
		if(recordByDeveloperName == null){
			recordByDeveloperName = new Map<String, CustomNotificationType>();
			for(CustomNotificationType customNotificationType : Database.query(newQueryFactory(false, false, true).setLimit(50000).toSOQL()))
				recordByDeveloperName.put(customNotificationType.DeveloperName, customNotificationType);
		}
		return recordByDeveloperName.get(developerName);
	}
}