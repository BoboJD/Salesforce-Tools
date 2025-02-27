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
 * Unit tests for ConnectApiService.
 *
 * This class works with API version 36.0 and later. There are separate classes
 * that work with v35.0 and earlier.
 *
 * See https://github.com/forcedotcom/ConnectApiService for more information.
 *
 */
@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue, PMD.AvoidHardcodingId')
@IsTest(SeeAllData=true)
private class ConnectApiServiceTest{

	@IsTest(SeeAllData=true)
	static void testNullString() {
		Boolean exceptionThrown = false;
		try {
			ConnectApiService.getMessageSegmentInputs(null);
		}
		catch (ConnectApiServiceImpl.InvalidParameterException e) {
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}

	@IsTest(SeeAllData=true)
	static void testEmptyString() {
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs('');
		Assert.equals(0, segments.size());
	}

	@IsTest(SeeAllData=true)
	static void testNoMentions() {
		String text = 'hey there';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(1, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.TextSegmentInput);
		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
		Assert.equals(text, textSegment.text);
	}

	@IsTest(SeeAllData=true)
	static void testMentionOnly() {
		String mentionId = '005x0000000URNPzzz';
		String text = '{' + mentionId + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(1, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
		ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
		Assert.equals(mentionId, mentionSegment.id);
	}

	@IsTest(SeeAllData=true)
	static void testLeadingMention() {
		String mentionId = '005x0000000URNPzzz';
		String restOfMessage = ' - how are you?';
		String text = '{' + mentionId + '}' + restOfMessage;
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(2, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.TextSegmentInput);

		ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
		Assert.equals(mentionId, mentionSegment.id);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
		Assert.equals(restOfMessage, textSegment.text);
	}

	@IsTest(SeeAllData=true)
	static void testTrailingMention() {
		String restOfMessage = 'Here we go: ';
		String mentionId = '005x0000000URNPzzz';
		String text = restOfMessage + '{' + mentionId + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(2, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
		Assert.equals(restOfMessage, textSegment.text);

		ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(1);
		Assert.equals(mentionId, mentionSegment.id);
	}

	@IsTest(SeeAllData=true)
	static void testAdjacentMentions() {
		String mentionId  = '005x0000000URNPzzz';
		String mentionId2 = '0F9x00000000D7mzzz';
		String text = '{' + mentionId + '}' + '{' + mentionId2 + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(2, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MentionSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.MentionSegmentInput);

		ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
		Assert.equals(mentionId, mentionSegment.id);

		ConnectApi.MentionSegmentInput mentionSegment2 = (ConnectApi.MentionSegmentInput) segments.get(1);
		Assert.equals(mentionId2, mentionSegment2.id);
	}

	@IsTest(SeeAllData=true)
	static void testLinkAndHashtagParsing() {
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IFeatureManagementService featureManagementServiceMock = new Mocks.FeatureManagementService(mocks);

		// The test string is: #Yolo: http://salesforce.com, {005} {005x0000000URNPzzz} test.
		//                     [   ][][                   ][      ][                  ][    ]
		//                     0    1 2                    3       4                   5
		// 0 = hashtag
		// 1 = text1
		// 2 = link
		// 3 = text2
		// 4 = mention
		// 5 = text3

		String hashtag = 'Yolo';
		String text1 = ': ';
		String link = 'http://salesforce.com';
		String text2 = ', {005} ';
		String mentionId = UserInfo.getUserId();
		String text3 = ' test.';
		String text = '#' + hashtag + text1 + link + text2 + '{' + mentionId + '}' + text3;

		mocks.startStubbing();
		mocks.when(featureManagementServiceMock.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION)).thenReturn(false);
		mocks.stopStubbing();

		Application.Service.setMock(IFeatureManagementService.class, featureManagementServiceMock);

		ConnectApi.FeedElement fi = ConnectApiService.postFeedItemWithRichText(null, 'me', text);

		((IFeatureManagementService)mocks.verify(featureManagementServiceMock)).checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);

		List<ConnectApi.MessageSegment> segments = fi.body.messageSegments;

		Assert.equals(6, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.HashtagSegment);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.TextSegment);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.LinkSegment);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.TextSegment);
		Assert.isTrue(segments.get(4) instanceof ConnectApi.MentionSegment);
		Assert.isTrue(segments.get(5) instanceof ConnectApi.TextSegment);

		ConnectApi.HashtagSegment hashtagSegment = (ConnectApi.HashtagSegment) segments.get(0);
		Assert.equals(hashtag, hashtagSegment.tag);

		ConnectApi.TextSegment textSegment1 = (ConnectApi.TextSegment) segments.get(1);
		Assert.equals(text1, textSegment1.text);

		ConnectApi.LinkSegment linkSegment = (ConnectApi.LinkSegment) segments.get(2);
		Assert.equals(link, linkSegment.url);

		ConnectApi.TextSegment textSegment2 = (ConnectApi.TextSegment) segments.get(3);
		Assert.equals(text2, textSegment2.text);

		ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(4);
		Assert.equals(mentionId, mentionSegment.record.id);

		ConnectApi.TextSegment textSegment3 = (ConnectApi.TextSegment) segments.get(5);
		Assert.equals(text3, textSegment3.text);
	}

	@IsTest(SeeAllData=true)
	static void testMentionInComment() {
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IFeatureManagementService featureManagementServiceMock = new Mocks.FeatureManagementService(mocks);
		
		mocks.startStubbing();
		mocks.when(featureManagementServiceMock.checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION)).thenReturn(false);
		mocks.stopStubbing();

		Application.Service.setMock(IFeatureManagementService.class, featureManagementServiceMock);

		ConnectApi.FeedElement fi = ConnectApi.ChatterFeeds.postFeedElement(null, 'me', ConnectApi.FeedElementType.FeedItem, 'hi');
		String mentionId = UserInfo.getUserId();
		String text = '{' + mentionId + '}';
		ConnectApi.Comment comment = ConnectApiService.postCommentWithMentions(null, fi.id, text);

		((IFeatureManagementService)mocks.verify(featureManagementServiceMock)).checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);

		List<ConnectApi.MessageSegment> segments = comment.body.messageSegments;
		Assert.equals(1, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MentionSegment);
		ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(0);
		Assert.equals(mentionId, mentionSegment.record.id);
	}

	@IsTest(SeeAllData=true)
	static void testCreateInputFromBody() {

		// We'll post a feed item that contains text, link, hashtag, mention, and markup segments,
		// and then call the helper method on the resulting body.

		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		// We can put the link and hashtag parts into a text segment to post the feed item. When it gets retrieved, it will have
		// separate segments for the text, link and hashtag.
		String expectedText = 'Text ';
		String expectedLink = 'http://link.com';
		String expectedHashtag = 'hashtag';
		String expectedBoldText = 'Bold text';

		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = expectedText + expectedLink + ' #' + expectedHashtag;
		messageBodyInput.messageSegments.add(textSegmentInput);

		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = UserInfo.getUserId();
		messageBodyInput.messageSegments.add(mentionSegmentInput);

		ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginSegmentInput.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupBeginSegmentInput);

		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = expectedBoldText;
		messageBodyInput.messageSegments.add(textSegmentInput);

		ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = new ConnectApi.MarkupEndSegmentInput();
		markupEndSegmentInput.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupEndSegmentInput);

		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = UserInfo.getUserId();

		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

		ConnectApi.MessageBodyInput input = ConnectApiService.createInputFromBody(feedElement.body);
		Assert.equals(8, input.messageSegments.size());

		Assert.isTrue(input.messageSegments.get(0) instanceof ConnectApi.TextSegmentInput);
		ConnectApi.TextSegmentInput textInput = (ConnectApi.TextSegmentInput) input.messageSegments.get(0);
		Assert.equals(expectedText, textInput.text);

		Assert.isTrue(input.messageSegments.get(1) instanceof ConnectApi.LinkSegmentInput);
		ConnectApi.LinkSegmentInput linkInput = (ConnectApi.LinkSegmentInput) input.messageSegments.get(1);
		Assert.equals(expectedLink, linkInput.url);

		Assert.isTrue(input.messageSegments.get(2) instanceof ConnectApi.TextSegmentInput);
		ConnectApi.TextSegmentInput textInput2 = (ConnectApi.TextSegmentInput) input.messageSegments.get(2);
		Assert.equals(' ', textInput2.text);

		Assert.isTrue(input.messageSegments.get(3) instanceof ConnectApi.HashtagSegmentInput);
		ConnectApi.HashtagSegmentInput hashtagInput = (ConnectApi.HashtagSegmentInput) input.messageSegments.get(3);
		Assert.equals(expectedHashtag, hashtagInput.tag);

		Assert.isTrue(input.messageSegments.get(4) instanceof ConnectApi.MentionSegmentInput);
		ConnectApi.MentionSegmentInput mentionInput = (ConnectApi.MentionSegmentInput) input.messageSegments.get(4);
		Assert.equals(UserInfo.getUserId(), mentionInput.id);

		Assert.isTrue(input.messageSegments.get(5) instanceof ConnectApi.MarkupBeginSegmentInput);
		ConnectApi.MarkupBeginSegmentInput markupBeginInput = (ConnectApi.MarkupBeginSegmentInput) input.messageSegments.get(5);
		Assert.equals(ConnectApi.MarkupType.Bold, markupBeginInput.markupType);

		Assert.isTrue(input.messageSegments.get(6) instanceof ConnectApi.TextSegmentInput);
		ConnectApi.TextSegmentInput textInput3 = (ConnectApi.TextSegmentInput) input.messageSegments.get(6);
		Assert.equals(expectedBoldText, textInput3.text);

		Assert.isTrue(input.messageSegments.get(7) instanceof ConnectApi.MarkupEndSegmentInput);
		ConnectApi.MarkupEndSegmentInput markupEndInput = (ConnectApi.MarkupEndSegmentInput) input.messageSegments.get(7);
		Assert.equals(ConnectApi.MarkupType.Bold, markupEndInput.markupType);

		// Get coverage for the createFeedItemInputFromBody() method.
		ConnectApi.FeedItemInput feedItemInput2 = ConnectApiService.createFeedItemInputFromBody(feedElement.body);
		Assert.equals(input, feedItemInput2.body);

		// Get coverage for the createCommentInputFromBody() method.
		ConnectApi.CommentInput commentInput = ConnectApiService.createCommentInputFromBody(feedElement.body);
		Assert.equals(input, commentInput.body);
	}

	@IsTest(SeeAllData=true)
	static void testCreateInputFromBodyWithGeneratedSegment() {
		ConnectApi.FeedBody body = new ConnectApi.FeedBody();
		body.messageSegments = new List<ConnectApi.MessageSegment>();

		// Mock up an entity link segment.
		ConnectApi.EntityLinkSegment entityLinkSegment = new ConnectApi.EntityLinkSegment();
		entityLinkSegment.text = 'blah';

		body.messageSegments.add(entityLinkSegment);
		body.text = 'blah';

		ConnectApi.MessageBodyInput input = ConnectApiService.createInputFromBody(body);
		Assert.equals(0, input.messageSegments.size());
	}


	@IsTest(SeeAllData=true)
	static void testUnsupportedMarkup() {
		// <span>a</span>, <h1><a>b</a> <br> <b>Does this work?</b></h1>
		// [0                               ][1][2            ][3 ][4  ]
		// 0 = text1
		// 1 = markup begin
		// 2 = text2
		// 3 = markup end
		// 4 = text3
		String text1 = '<span>a</span>, <h1><a>b</a> <br> ';
		String text2 = 'Does this work?';
		String text3 = '</h1>';
		String text = text1 + '<b>' + text2 + '</b>' + text3;

		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(5, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(4) instanceof ConnectApi.TextSegmentInput);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
		Assert.equals(text1, textSegment.text);

		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
		Assert.equals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
		Assert.equals(text2, textSegment.text);

		ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
		Assert.equals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
		Assert.equals(text3, textSegment.text);
	}

	@IsTest(SeeAllData=true)
	static void testSimpleMarkup() {
		String restOfMessage = 'blah';
		String text = '<u>' + restOfMessage + '</u>';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(3, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);

		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
		Assert.equals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
		Assert.equals(restOfMessage, textSegment.text);

		ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
		Assert.equals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);
	}

	@IsTest(SeeAllData=true)
	static void testMarkupCasing() {
		String text1 = 'foo';
		String text2 = 'bar';
		String text3 = 'baz';
		String text = '<U>' + text1 + '</U><b>' + text2 + '</B><oL><li>' + text3 + '</li></oL>';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(11, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(4) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(5) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(8) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);

		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
		Assert.equals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
		Assert.equals(text1, textSegment.text);

		ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
		Assert.equals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(3);
		Assert.equals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
		Assert.equals(text2, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(5);
		Assert.equals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
		Assert.equals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
		Assert.equals(text3, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
		Assert.equals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);
	}

	@IsTest(SeeAllData=true)
	static void testInlineImage() {
		String restOfMessage = 'Check out this image!';
		String imageId = '069B0000000q7hi';
		String altText = 'Some alt text.';
		String text = restOfMessage + '{img:' + imageId + ':' + altText + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(2, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
		Assert.equals(restOfMessage, textSegment.text);

		ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
		Assert.equals(imageId, inlineImageSegment.fileId);
		Assert.equals(altText, inlineImageSegment.altText);
	}

	@IsTest(SeeAllData=true)
	static void testInlineImageNoAltText() {
		String imageId = '069B0000000q7hi';
		String text = '{img:' + imageId + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(1, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);

		ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
		Assert.equals(imageId, inlineImageSegment.fileId);
		Assert.isNull(inlineImageSegment.altText);
	}

	@IsTest(SeeAllData=true)
	static void testInlineImageAltTextSyntax() {
		String imageId15 = '069B0000000q7hi';
		String imageId18 = '069B0000000q7hixxx';
		String altText1 = 'Alt text with a colon : in the middle.';
		String badSyntax1 = 'Alt text with a closing brace ';
		String badSyntax2 = ' in the middle.}';
		String badSyntaxAltText = badSyntax1 + '}' + badSyntax2;
		String text = '{img:' + imageId15 + ':' + altText1 + '}{img:' + imageId18 + ':}{img:' + imageId15 + ':' + badSyntaxAltText;
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(4, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.InlineImageSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.InlineImageSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.InlineImageSegmentInput);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.TextSegmentInput);

		ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
		Assert.equals(imageId15, inlineImageSegment.fileId);
		Assert.equals(altText1, inlineImageSegment.altText);

		inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
		Assert.equals(imageId18, inlineImageSegment.fileId);
		Assert.isNull(inlineImageSegment.altText);

		inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(2);
		Assert.equals(imageId15, inlineImageSegment.fileId);
		Assert.equals(badSyntax1, inlineImageSegment.altText);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(3);
		Assert.equals(badSyntax2, textSegment.text);
	}

	@IsTest(SeeAllData=true)
	static void testMarkupAndMention() {
		String mentionId = '005x0000000URNPzzz';
		String message = 'How are you';
		String questionMark = '?';
		String text = '<b>' + message + '<i>{' + mentionId + '}</i>' + questionMark + '</b>';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(7, segments.size());
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.MentionSegmentInput);
		Assert.isTrue(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(5) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(6) instanceof ConnectApi.MarkupEndSegmentInput);

		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
		Assert.equals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
		Assert.equals(message, textSegment.text);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(2);
		Assert.equals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

		ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(3);
		Assert.equals(mentionId, mentionSegment.id);

		ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
		Assert.equals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(5);
		Assert.equals(questionMark, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(6);
		Assert.equals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);
	}

	@IsTest(SeeAllData=true)
	static void testAllMarkupAndInlineImage() {
		// <p><i>This is an italicized paragraph.</i></p>
		// <ul><li><s>A completed item in an unordered list.</s></li></ul>
		// <ol><li><u>An underlined item in an ordered list.</u></li></ol>
		// <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
		String text1 = 'This is an italicized paragraph.';
		String text2 = 'A completed item in an unordered list.';
		String text3 = 'An underlined item in an ordered list.';
		String text4 = 'And, of course, an image for you: ';
		String text5 = ' ';
		String imageId = '069B0000000q7hi';
		String altText = 'An image of something nice.';
		String text = '<p><i>' + text1 + '</i></p><ul><li><s>' + text2 + '</s></li></ul><ol><li><u>'
				+ text3 + '</u></li></ol><b>' + text4 + '</b> {img:' + imageId + ':' + altText + '}';
		List<ConnectApi.MessageSegmentInput> segments = ConnectApiService.getMessageSegmentInputs(text);

		Assert.equals(24, segments.size());
		// <p><i>This is an italicized paragraph.</i></p>
		Assert.isTrue(segments.get(0) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(1) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(2) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(3) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(4) instanceof ConnectApi.MarkupEndSegmentInput);

		// <ul><li><s>A completed item in an unordered list.</s></li></ul>
		Assert.isTrue(segments.get(5) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(6) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(7) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(8) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(9) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(10) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(11) instanceof ConnectApi.MarkupEndSegmentInput);

		// <ol><li><u>An underlined item in an ordered list.</u></li></ol>
		Assert.isTrue(segments.get(12) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(13) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(14) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(15) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(16) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(17) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(18) instanceof ConnectApi.MarkupEndSegmentInput);

		// <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
		Assert.isTrue(segments.get(19) instanceof ConnectApi.MarkupBeginSegmentInput);
		Assert.isTrue(segments.get(20) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(21) instanceof ConnectApi.MarkupEndSegmentInput);
		Assert.isTrue(segments.get(22) instanceof ConnectApi.TextSegmentInput);
		Assert.isTrue(segments.get(23) instanceof ConnectApi.InlineImageSegmentInput);

		// <p><i>This is an italicized paragraph.</i></p>
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
		Assert.equals(ConnectApi.MarkupType.Paragraph, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
		Assert.equals(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

		ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
		Assert.equals(text1, textSegment.text);

		ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
		Assert.equals(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
		Assert.equals(ConnectApi.MarkupType.Paragraph, markupEndSegment.markupType);

		// <ul><li><s>A completed item in an unordered list.</s></li></ul>
		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(5);
		Assert.equals(ConnectApi.MarkupType.UnorderedList, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
		Assert.equals(ConnectApi.MarkupType.Strikethrough, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
		Assert.equals(text2, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
		Assert.equals(ConnectApi.MarkupType.Strikethrough, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(11);
		Assert.equals(ConnectApi.MarkupType.UnorderedList, markupEndSegment.markupType);

		// <ol><li><u>An underlined item in an ordered list.</u></li></ol>
		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(12);
		Assert.equals(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(13);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(14);
		Assert.equals(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(15);
		Assert.equals(text3, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(16);
		Assert.equals(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(17);
		Assert.equals(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(18);
		Assert.equals(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);

		// <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
		markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(19);
		Assert.equals(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(20);
		Assert.equals(text4, textSegment.text);

		markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(21);
		Assert.equals(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

		textSegment = (ConnectApi.TextSegmentInput) segments.get(22);
		Assert.equals(text5, textSegment.text);

		ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(23);
		Assert.equals(imageId, inlineImageSegment.fileId);
		Assert.equals(altText, inlineImageSegment.altText);
	}
}