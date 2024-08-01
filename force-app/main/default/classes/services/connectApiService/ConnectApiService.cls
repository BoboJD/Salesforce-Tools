public inherited sharing class ConnectApiService{

	public static ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){
		return service().postFeedItemWithMentions(communityId, subjectId, textWithMentions);
	}

	public static ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText){
		return service().postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText);
	}

	public static ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions){
		return service().postCommentWithMentions(communityId, feedItemId, textWithMentions);
	}

	public static List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText){
		return service().getMessageSegmentInputs(inputText);
	}

	public static ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body){
		return service().createInputFromBody(body);
	}

	public static ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body){
		return service().createFeedItemInputFromBody(body);
	}

	public static ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body){
		return service().createCommentInputFromBody(body);
	}
	
	private static IConnectApiService service(){
		return (IConnectApiService)Application.Service.newInstance(IConnectApiService.class);
	}
}