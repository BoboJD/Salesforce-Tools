@IsTest
private class EmailServiceTest{

	@IsTest
	static void sendErrorToCurrentUserShouldCallMessagingService(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IMessagingService messagingServiceMock = new Mocks.MessagingService(mocks);

		String subject = 'subject';
		String body = 'html';

		Application.Service.setMock(IMessagingService.class, messagingServiceMock);

		Test.startTest();
		EmailService.sendErrorToCurrentUser(subject, body);
		Test.stopTest();

		((IMessagingService)mocks.verify(messagingServiceMock)).newSingleEmailMessage();
		((IMessagingService)mocks.verify(messagingServiceMock)).setSenderDisplayName(Label.EmailNoReplySenderDisplayName);
		((IMessagingService)mocks.verify(messagingServiceMock)).setToAddress(UserInfo.getUserId());
		((IMessagingService)mocks.verify(messagingServiceMock)).setUseSignature(false);
		((IMessagingService)mocks.verify(messagingServiceMock)).setSaveAsActivity(false);
		((IMessagingService)mocks.verify(messagingServiceMock)).setSubject(subject);
		((IMessagingService)mocks.verify(messagingServiceMock)).setHtmlBody(body);
		((IMessagingService)mocks.verify(messagingServiceMock)).sendEmails();
	}
}