public interface IConnectApiService {
	ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions);
	ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText);
	ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions);
	List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText);
	ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body);
	ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body);
	ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body);
}