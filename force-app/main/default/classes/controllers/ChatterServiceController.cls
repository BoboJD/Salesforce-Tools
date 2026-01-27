global without sharing class ChatterServiceController{

	@AuraEnabled
	global static Map<String, Object> postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){
		Map<String, Object> result = new Map<String, Object>();
		try{
			ConnectApi.FeedElement feedElement = ConnectApiService.postFeedItemWithMentions(communityId, subjectId, textWithMentions);
			result = ControllerUtils.success('feedElement', feedElement);
		}catch(Exception e){
			LogFactory.commitError(ChatterServiceController.class, 'postFeedItemWithMentions', new List<Object>{ communityId, subjectId, textWithMentions }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}

	@AuraEnabled
	global static Map<String, Object> postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText){
		Map<String, Object> result = new Map<String, Object>();
		try{
			ConnectApi.FeedElement feedElement = ConnectApiService.postFeedItemWithRichText(communityId, subjectId, textWithMentionsAndRichText);
			result = ControllerUtils.success('feedElement', feedElement);
		}catch(Exception e){
			LogFactory.commitError(ChatterServiceController.class, 'postFeedItemWithRichText', new List<Object>{ communityId, subjectId, textWithMentionsAndRichText }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}

	@AuraEnabled
	global static Map<String, Object> postCommentWithMentions(String communityId, String feedItemId, String textWithMentions){
		Map<String, Object> result = new Map<String, Object>();
		try{
			ConnectApi.Comment comment = ConnectApiService.postCommentWithMentions(communityId, feedItemId, textWithMentions);
			result = ControllerUtils.success('comment', comment);
		}catch(Exception e){
			LogFactory.commitError(ChatterServiceController.class, 'postCommentWithMentions', new List<Object>{ communityId, feedItemId, textWithMentions }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}
}
