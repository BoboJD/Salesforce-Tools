@SuppressWarnings('PMD.ExcessiveParameterList')
public inherited sharing class CustomNotificationsService{

	public static void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body){
		service().notifyUsers(targetId, recipientsIds, title, body);
	}

	private static ICustomNotificationsService service(){
		return (ICustomNotificationsService)Application.Service.newInstance(ICustomNotificationsService.class);
	}
}