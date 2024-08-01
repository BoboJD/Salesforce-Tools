@SuppressWarnings('PMD.ExcessiveParameterList')
public inherited sharing class CustomNotificationsServiceImpl implements ICustomNotificationsService{
	@TestVisible private static Messaging.CustomNotification notification;

	public void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body){
		CustomNotificationType notificationType = CustomNotificationTypesSelector.newInstance().selectByDeveloperName(CustomNotificationConstants.CUSTOM_NOTIFICATION);
		notification = new Messaging.CustomNotification();
		if(String.isNotBlank(title))
			notification.setTitle(title);
		if(String.isNotBlank(body))
			notification.setBody(body);
		notification.setNotificationTypeId(notificationType.Id);
		notification.setTargetId(targetId);
		notification.send(recipientsIds);
	}
}