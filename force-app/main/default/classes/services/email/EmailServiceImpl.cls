global inherited sharing class EmailServiceImpl implements IEmailService{

	global void sendErrorToCurrentUser(String subject, String body){
		MessagingService.newSingleEmailMessage();
		MessagingService.setSenderDisplayName(Label.EmailNoReplySenderDisplayName);
		MessagingService.setToAddress(UserInfo.getUserId());
		MessagingService.setUseSignature(false);
		MessagingService.setSaveAsActivity(false);
		MessagingService.setSubject(subject);
		MessagingService.setHtmlBody(body);
		MessagingService.sendEmails();
	}
}