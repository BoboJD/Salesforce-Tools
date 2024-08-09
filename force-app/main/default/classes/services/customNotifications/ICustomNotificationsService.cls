@SuppressWarnings('PMD.ExcessiveParameterList')
global interface ICustomNotificationsService{
	void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body);
}