/*
Copyright (c) 2016, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	* Neither the name of the salesforce.com, Inc. nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *
 * Helper class that makes it easier to do common operations with the classes in the ConnectApi namespace.
 *
 * Includes convenience methods to:
 *
 *     - Post Chatter @-mentions, rich text, and inline images with Apex code.
 *     - Take a feed item or comment body and return an input body that matches it.
 *       This is useful for when you retrieve a feed item or comment and want to either
 *       re-post or edit it.
 *
 * This class works with API version 36.0 and later. There are separate classes
 * that work with v35.0 and earlier.
 *
 * See https://github.com/forcedotcom/ConnectApiHelper for more information.
 *
 */
@SuppressWarnings('PMD')
global inherited sharing class ConnectApiServiceImpl implements IConnectApiService{

	private static final Map<String, ConnectApi.MarkupType> SUPPORTED_MARKUP = new Map<String, ConnectApi.MarkupType> {
		'b' => ConnectApi.MarkupType.Bold,
		'i' => ConnectApi.MarkupType.Italic,
		'li' => ConnectApi.MarkupType.ListItem,
		'ol' => ConnectApi.MarkupType.OrderedList,
		'p' => ConnectApi.MarkupType.Paragraph,
		's' => ConnectApi.MarkupType.Strikethrough,
		'u' => ConnectApi.MarkupType.Underline,
		'ul' => ConnectApi.MarkupType.UnorderedList
	};

	global class InvalidParameterException extends Exception {}

	/**
	 * Posts a feed item with @-mentions using an @-mention formatting syntax.
	 *
	 * @param communityId Use either the ID of a community, 'internal', or null.
	 * @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
	 * @param textWithMentions The text of the post. You can @-mention a user or group by using
	 *                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
	 *                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
	 *                         automatically parsed if provided.
	 * @return The posted feed item.
	 */
	global ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions) {
		return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentions, 'textWithMentions');
	}

	/**
	 * Posts a feed item with rich text using HTML tags and inline image formatting syntax.
	 *
	 * @param communityId Use either the ID of a community, 'internal', or null.
	 * @param subjectId The parent of the post. Can be a user ID, a group ID, or a record ID.
	 * @param textWithMentionsAndRichText The text of the post. You can @-mention a
	 *                         user or group by using the syntax {ID}, for example:
	 *                         'Hello {005x0000000URNP}, have you seen the group {0F9x00000000D7m}?'
	 *                         You can include rich text by using supported HTML tags:
	 *                         <b>, <i>, <u>, <s>, <ul>, <ol>, <li>, <p>.
	 *                         You can include an inline image by using the syntax {img:ID} or
	 *                         {img:ID:alt text}, for example: 'Have you seen this gorgeous view?
	 *                         {img:069x00000000D7m:View of the Space Needle from our office.}?'
	 *                         Links and hashtags will be automatically parsed if provided.
	 * @return The posted feed item.
	 */
	global ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText) {
		return postFeedItemWithSpecialFormatting(communityId, subjectId, textWithMentionsAndRichText, 'textWithMentionsAndRichText');
	}

	private ConnectApi.FeedElement postFeedItemWithSpecialFormatting(String communityId, String subjectId, String formattedText, String textParameterName) {
		Boolean notificationCanBeSent = !FeatureManagementService.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
		if(!notificationCanBeSent)
			return null;
		if (formattedText == null || formattedText.trim().length() == 0) {
			throw new InvalidParameterException('The ' + textParameterName + ' parameter must be non-empty.');
		}
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		messageInput.messageSegments = getMessageSegmentInputs(formattedText);
		ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
		input.body = messageInput;
		input.subjectId = subjectId;
		return ConnectApi.ChatterFeeds.postFeedElement(communityId, input);
	}

	/**
	 * Posts a comment with @-mentions using an @-mention formatting syntax.
	 *
	 * @param communityId Use either the ID of a community, 'internal', or null.
	 * @param feedItemId The ID of the feed item being commented on.
	 * @param textWithMentions The text of the comment. You can @-mention a user or group by using
	 *                         the syntax {ID}, for example: 'Hello {005x0000000URNP}, have you
	 *                         seen the group {0F9x00000000D7m}?' Links and hashtags will be
	 *                         automatically parsed if provided.
	 * @return The posted comment.
	 */
	global ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions) {
		Boolean notificationCanBeSent = !FeatureManagementService.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
		if(!notificationCanBeSent)
			return null;
		if (textWithMentions == null || textWithMentions.trim().length() == 0) {
			throw new InvalidParameterException('The textWithMentions parameter must be non-empty.');
		}
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		messageInput.messageSegments = getMessageSegmentInputs(textWithMentions);
		ConnectApi.CommentInput input = new ConnectApi.CommentInput();
		input.body = messageInput;
		return ConnectApi.ChatterFeeds.postCommentToFeedElement(communityId, feedItemId, input, null);
	}

	global List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText) {
		if (inputText == null) {
			throw new InvalidParameterException('The inputText parameter cannot be null.');
		}
		List<ConnectApi.MessageSegmentInput> messageSegmentInputs = new List<ConnectApi.MessageSegmentInput>();
		Integer strPos = 0;
		// The pattern for matching mentions, markup begin/end tags, and inline images.
		// The first group matches a 15 or 18 character ID surrounded by {}:
		//   (\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})
		// The second/third groups match beginning/ending HTML tags: (<[a-zA-Z]*>)|(</[a-zA-Z]*>)
		// The fourth group matches a 15 or 18 character content document ID preceded by "img:",
		//    optionally followed by a string (not containing '}'), and surrounded by {}:
		//    (\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})
		Pattern globalPattern = Pattern.compile('(\\{[a-zA-Z0-9]{15}\\}|\\{[a-zA-Z0-9]{18}\\})|(<[a-zA-Z][^>]*>)|(</[a-zA-Z]*>)|(\\{img:(069[a-zA-Z0-9]{12,15})(:[\\s\\S]*?)?\\})');
		Matcher globalMatcher = globalPattern.matcher(inputText);
		while (globalMatcher.find()) {
			String textSegment = inputText.substring(strPos, globalMatcher.start());
			String matchingText = globalMatcher.group();
			if (matchingText.startsWith('{')) {
				// Add a segment for any accumulated text (which includes unsupported HTML tags).
				addTextSegment(messageSegmentInputs, textSegment);
				// Strip off the { and }.
				String innerMatchedText = matchingText.substring(1, matchingText.length() - 1);
				if (innerMatchedText.startsWith('img:')) {
					// This is an inline image.
					String[] imageInfo = innerMatchedText.split(':', 3);
					String altText = imageInfo.size() == 3 ? imageInfo[2] : null;
					ConnectApi.InlineImageSegmentInput inlineImageSegmentInput = makeInlineImageSegmentInput(imageInfo[1], altText);
					messageSegmentInputs.add(inlineImageSegmentInput);
					strPos = globalMatcher.end();
				}
				else {
					// This is a mention id.
					Id recordId = (Id)innerMatchedText;
					if (recordId.getSobjectType() == User.SObjectType || recordId.getSobjectType() == CollaborationGroup.SObjectType){
						ConnectApi.MentionSegmentInput mentionSegmentInput = makeMentionSegmentInput(recordId);
						messageSegmentInputs.add(mentionSegmentInput);
					} else {
						ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = makeEntityLinkSegmentInput(recordId);
						messageSegmentInputs.add(entityLinkSegmentInput);
					}
					strPos = globalMatcher.end();
				}
			}
			else {
				// This is an HTML tag.
				boolean isBeginTag = !matchingText.startsWith('</');
				if (isBeginTag) {
					// Strip off the < and >.
					String tag = matchingText.substring(1, matchingText.indexOf('>'));
					if (SUPPORTED_MARKUP.containsKey(tag.toLowerCase())) {
						// Add a segment for any accumulated text (which includes unsupported HTML tags).
						addTextSegment(messageSegmentInputs, textSegment);
						ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = makeMarkupBeginSegmentInput(tag);
						messageSegmentInputs.add(markupBeginSegmentInput);
						strPos = globalMatcher.end();
					}
				}
				else { // This is an end tag.
					// Strip off the </ and >.
					String tag = matchingText.substring(2, matchingText.indexOf('>'));
					if (SUPPORTED_MARKUP.containsKey(tag.toLowerCase())) {
						// Add a segment for any accumulated text (which includes unsupported HTML tags).
						addTextSegment(messageSegmentInputs, textSegment);
						ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = makeMarkupEndSegmentInput(tag);
						messageSegmentInputs.add(markupEndSegmentInput);
						strPos = globalMatcher.end();
					}
				}
			}
		}
		// Take care of any text that comes after the last match.
		if (strPos < inputText.length()) {
			String trailingText = inputText.substring(strPos, inputText.length());
			addTextSegment(messageSegmentInputs, trailingText);
		}
		return messageSegmentInputs;
	}

	private void addTextSegment(List<ConnectApi.MessageSegmentInput> messageSegmentInputs, String text) {
		if (text != null && text.length() > 0) {
			ConnectApi.TextSegmentInput textSegmentInput = makeTextSegmentInput(text);
			messageSegmentInputs.add(textSegmentInput);
		}
	}

	private ConnectApi.TextSegmentInput makeTextSegmentInput(String text) {
		ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
		textSegment.text = text;
		return textSegment;
	}

	private ConnectApi.MentionSegmentInput makeMentionSegmentInput(String mentionId) {
		ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
		mentionSegment.id = mentionId;
		return mentionSegment;
	}

	private ConnectApi.EntityLinkSegmentInput makeEntityLinkSegmentInput(String entityId) {
		ConnectApi.EntityLinkSegmentInput mentionSegment = new ConnectApi.EntityLinkSegmentInput();
		mentionSegment.entityId = entityId;
		return mentionSegment;
	}

	/**
	 * Create a MarkupBeginSegmentInput corresponding to the tag.  Checking whether the tag is
	 * supported markup should happen before calling this method.
	 */
	private ConnectApi.MarkupBeginSegmentInput makeMarkupBeginSegmentInput(String tag) {
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginSegment.markupType = SUPPORTED_MARKUP.get(tag.toLowerCase());
		return markupBeginSegment;
	}

	/**
	 * Create a MarkupEndSegmentInput corresponding to the tag.  Checking whether the tag is
	 * supported markup should happen before calling this method.
	 */
	private ConnectApi.MarkupEndSegmentInput makeMarkupEndSegmentInput(String tag) {
		ConnectApi.MarkupEndSegmentInput markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
		markupEndSegment.markupType = SUPPORTED_MARKUP.get(tag.toLowerCase());
		return markupEndSegment;
	}

	private ConnectApi.InlineImageSegmentInput makeInlineImageSegmentInput(String fileId, String altText) {
		ConnectApi.InlineImageSegmentInput inlineImageSegment = new ConnectApi.InlineImageSegmentInput();
		inlineImageSegment.fileId = fileId;
		if (String.isNotBlank(altText)) {
			inlineImageSegment.altText = altText;
		}
		return inlineImageSegment;
	}

	/**
	 * Takes an output feed body and returns a message body input that matches it.
	 * This is useful for when you retrieve a feed item or comment and want to either re-post or edit it.
	 */
	global ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body) {
		ConnectApi.MessageBodyInput input = new ConnectApi.MessageBodyInput();
		input.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		for (ConnectApi.MessageSegment segment : body.messageSegments) {
			if (segment instanceof ConnectApi.TextSegment) {
				ConnectApi.TextSegment textOutput = (ConnectApi.TextSegment) segment;
				ConnectApi.TextSegmentInput textInput = new ConnectApi.TextSegmentInput();
				textInput.text = textOutput.text;
				input.messageSegments.add(textInput);
			}
			else if (segment instanceof ConnectApi.MentionSegment) {
				ConnectApi.MentionSegment mentionOutput = (ConnectApi.MentionSegment) segment;
				ConnectApi.MentionSegmentInput mentionInput = new ConnectApi.MentionSegmentInput();
				mentionInput.id = mentionOutput.record.id;
				input.messageSegments.add(mentionInput);
			}
			else if (segment instanceof ConnectApi.HashtagSegment) {
				ConnectApi.HashtagSegment hashtagOutput = (ConnectApi.HashtagSegment) segment;
				ConnectApi.HashtagSegmentInput hashtagInput = new ConnectApi.HashtagSegmentInput();
				hashtagInput.tag = hashtagOutput.tag;
				input.messageSegments.add(hashtagInput);
			}
			else if (segment instanceof ConnectApi.LinkSegment) {
				ConnectApi.LinkSegment linkOutput = (ConnectApi.LinkSegment) segment;
				ConnectApi.LinkSegmentInput linkInput = new ConnectApi.LinkSegmentInput();
				linkInput.url = linkOutput.url;
				input.messageSegments.add(linkInput);
			}
			else if (segment instanceof ConnectApi.MarkupBeginSegment) {
				ConnectApi.MarkupBeginSegment markupBeginOutput = (ConnectApi.MarkupBeginSegment) segment;
				ConnectApi.MarkupBeginSegmentInput markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
				markupBeginInput.markupType = markupBeginOutput.markupType;
				input.messageSegments.add(markupBeginInput);
			}
			else if (segment instanceof ConnectApi.MarkupEndSegment) {
				ConnectApi.MarkupEndSegment markupEndOutput = (ConnectApi.MarkupEndSegment) segment;
				ConnectApi.MarkupEndSegmentInput markupEndInput = new ConnectApi.MarkupEndSegmentInput();
				markupEndInput.markupType = markupEndOutput.markupType;
				input.messageSegments.add(markupEndInput);
			}
			else if (segment instanceof ConnectApi.InlineImageSegment) {
				ConnectApi.InlineImageSegment inlineImageOutput = (ConnectApi.InlineImageSegment) segment;
				ConnectApi.InlineImageSegmentInput inlineImageInput = new ConnectApi.InlineImageSegmentInput();
				inlineImageInput.fileId = inlineImageOutput.thumbnails.fileId;
				inlineImageInput.altText = inlineImageOutput.altText;
				input.messageSegments.add(inlineImageInput);
			}
			else {
				// The other segment types are system-generated and have no corresponding input types.
			}
		}
		return input;
	}

	/**
	 * Takes an output body and returns a feed item input body that matches it.
	 * This is useful for when you retrieve a feed item and want to either re-post or edit it.
	 */
	global ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body) {
		ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
		ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
		input.body = bodyInput;
		return input;
	}

	/**
	 * Takes an output body and returns a comment input body that matches it.
	 * This is useful for when you retrieve a comment and want to either re-post or edit it.
	 */
	global ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body) {
		ConnectApi.MessageBodyInput bodyInput = createInputFromBody(body);
		ConnectApi.CommentInput input = new ConnectApi.CommentInput();
		input.body = bodyInput;
		return input;
	}
}