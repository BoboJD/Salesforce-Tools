import postFeedItemWithMentionsApex from '@salesforce/apex/ChatterServiceController.postFeedItemWithMentions';
import postFeedItemWithRichTextApex from '@salesforce/apex/ChatterServiceController.postFeedItemWithRichText';
import postCommentWithMentionsApex from '@salesforce/apex/ChatterServiceController.postCommentWithMentions';

const postFeedItemWithMentions = (communityId, subjectId, textWithMentions) => {
	return postFeedItemWithMentionsApex({ communityId, subjectId, textWithMentions });
};

const postFeedItemWithRichText = (communityId, subjectId, textWithMentionsAndRichText) => {
	return postFeedItemWithRichTextApex({ communityId, subjectId, textWithMentionsAndRichText });
};

const postCommentWithMentions = (communityId, feedItemId, textWithMentions) => {
	return postCommentWithMentionsApex({ communityId, feedItemId, textWithMentions });
};

export {
	postFeedItemWithMentions,
	postFeedItemWithRichText,
	postCommentWithMentions
};