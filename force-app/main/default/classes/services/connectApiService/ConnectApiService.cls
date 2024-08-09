global inherited sharing class ConnectApiService{

	global static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){
		return service().postFeedItemWithMentions(communityId, subjectId, textWithMentions);
	}

	global static ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText){
		return service().postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText);
	}

	global static ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions){
		return service().postCommentWithMentions(communityId, feedItemId, textWithMentions);
	}

	global static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText){
		return service().getMessageSegmentInputs(inputText);
	}

	global static ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body){
		return service().createInputFromBody(body);
	}

	global static ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body){
		return service().createFeedItemInputFromBody(body);
	}

	global static ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body){
		return service().createCommentInputFromBody(body);
	}
	
	private static IConnectApiService service(){
		return (IConnectApiService)Application.Service.newInstance(IConnectApiService.class);
	}
}