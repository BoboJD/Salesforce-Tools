@IsTest
private class ChatterServiceControllerTest{

	@IsTest
	static void postFeedItemWithMentionsShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IConnectApiService connectApiServiceMock = new Mocks.ConnectApiService(mocks);

		String communityId = null;
		String subjectId = 'me';
		String textWithMentions = 'Hello {005x0000000URNPzzz}!';

		mocks.startStubbing();
		mocks.when(connectApiServiceMock.postFeedItemWithMentions(communityId, subjectId, textWithMentions)).thenReturn(null);
		mocks.stopStubbing();

		Application.Service.setMock(IConnectApiService.class, connectApiServiceMock);

		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postFeedItemWithMentions(communityId, subjectId, textWithMentions);
		Test.stopTest();

		((IConnectApiService)mocks.verify(connectApiServiceMock)).postFeedItemWithMentions(communityId, subjectId, textWithMentions);

		Assert.success(result);
	}

	@IsTest
	static void postFeedItemWithMentionsShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postFeedItemWithMentions(null, null, null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void postFeedItemWithRichTextShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IConnectApiService connectApiServiceMock = new Mocks.ConnectApiService(mocks);

		String communityId = null;
		String subjectId = 'me';
		String textWithMentionsAndRichText = '<b>Hello</b> {005x0000000URNPzzz}!';

		mocks.startStubbing();
		mocks.when(connectApiServiceMock.postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText)).thenReturn(null);
		mocks.stopStubbing();

		Application.Service.setMock(IConnectApiService.class, connectApiServiceMock);

		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText);
		Test.stopTest();

		((IConnectApiService)mocks.verify(connectApiServiceMock)).postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText);

		Assert.success(result);
	}

	@IsTest
	static void postFeedItemWithRichTextShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postFeedItemWithRichText(null, null, null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void postCommentWithMentionsShouldReturnSuccess(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IConnectApiService connectApiServiceMock = new Mocks.ConnectApiService(mocks);

		String communityId = null;
		String feedItemId = '0D5000000000001';
		String textWithMentions = 'Nice post {005x0000000URNPzzz}!';

		mocks.startStubbing();
		mocks.when(connectApiServiceMock.postCommentWithMentions(communityId, feedItemId, textWithMentions)).thenReturn(null);
		mocks.stopStubbing();

		Application.Service.setMock(IConnectApiService.class, connectApiServiceMock);

		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postCommentWithMentions(communityId, feedItemId, textWithMentions);
		Test.stopTest();

		((IConnectApiService)mocks.verify(connectApiServiceMock)).postCommentWithMentions(communityId, feedItemId, textWithMentions);

		Assert.success(result);
	}

	@IsTest
	static void postCommentWithMentionsShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = ChatterServiceController.postCommentWithMentions(null, null, null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}
}
