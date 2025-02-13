@SuppressWarnings('PMD.ExcessiveParameterList')
global inherited sharing class CustomNotificationsServiceImpl implements ICustomNotificationsService{
	@TestVisible private static Messaging.CustomNotification notification;

	global void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body){
		CustomNotificationType notificationType = tlz_CustomNotificationTypesSelector.newInstance().selectByDeveloperName(CustomNotificationConstants.CUSTOM_NOTIFICATION);
		notification = new Messaging.CustomNotification();
		if(String.isNotBlank(title))
			notification.setTitle(title);
		if(String.isNotBlank(body))
			notification.setBody(body);
		notification.setNotificationTypeId(notificationType.Id);
		notification.setTargetId(targetId ?? '000000000000000AAA');
		notification.send(recipientsIds);
	}

	global void notifyUser(String recipientId, String title, String body){
		notifyUsers(null, new Set<String>{recipientId}, title, body);
	}
}