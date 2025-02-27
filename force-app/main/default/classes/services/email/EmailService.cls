global inherited sharing class EmailService{

	global static void sendErrorToCurrentUser(String subject, String body){
		service().sendErrorToCurrentUser(subject, body);
	}

	private static IEmailService service(){
		return (IEmailService)Application.Service.newInstance(IEmailService.class);
	}
}