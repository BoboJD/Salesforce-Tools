@IsTest
global class Mocks{

	global class ConnectApiService implements IConnectApiService{
		private fflib_ApexMocks mocks;

		global ConnectApiService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){
			return (ConnectApi.FeedElement)mocks.mockNonVoidMethod(this, 'postFeedItemWithMentions', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, subjectId, textWithMentions});
		}

		global ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText){
			return (ConnectApi.FeedElement)mocks.mockNonVoidMethod(this, 'postFeedItemWithRichText', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, subjectId, textWithMentionsAndRichText});
		}

		global ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions){
			return (ConnectApi.Comment)mocks.mockNonVoidMethod(this, 'postCommentWithMentions', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, feedItemId, textWithMentions});
		}

		global List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText){
			return (List<ConnectApi.MessageSegmentInput>)mocks.mockNonVoidMethod(this, 'getMessageSegmentInputs', new List<Type>{String.class}, new List<Object>{inputText});
		}

		global ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.MessageBodyInput)mocks.mockNonVoidMethod(this, 'createInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}

		global ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.FeedItemInput)mocks.mockNonVoidMethod(this, 'createFeedItemInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}

		global ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.CommentInput)mocks.mockNonVoidMethod(this, 'createCommentInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}
	}

	global class ContentDocumentLinksSelector extends fflib_SObjectMocks.SObjectSelector implements IContentDocumentLinksSelector{
		private fflib_ApexMocks mocks;

		global ContentDocumentLinksSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds){
			return (List<ContentDocumentLink>)mocks.mockNonVoidMethod(this, 'selectByLinkedEntityIds', new List<Type>{Set<Id>.class}, new List<Object>{linkedEntityIds});
		}

		global Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds){
			return (Map<Id, List<ContentDocumentLink>>)mocks.mockNonVoidMethod(this, 'mapByContentDocumentId', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	global class ContentDocumentsSelector extends fflib_SObjectMocks.SObjectSelector implements IContentDocumentsSelector{
		private fflib_ApexMocks mocks;

		global ContentDocumentsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global List<ContentDocument> selectByIds(Set<Id> contentDocumentIds){
			return (List<ContentDocument>)mocks.mockNonVoidMethod(this, 'selectByIds', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	global class ContentVersionsSelector extends fflib_SObjectMocks.SObjectSelector implements IContentVersionsSelector{
		private fflib_ApexMocks mocks;

		global ContentVersionsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global List<ContentVersion> selectLatestByContentDocumentIds(Set<Id> contentDocumentIds){
			return (List<ContentVersion>)mocks.mockNonVoidMethod(this, 'selectLatestByContentDocumentIds', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	global class CustomNotificationsService implements ICustomNotificationsService{
		private fflib_ApexMocks mocks;

		global CustomNotificationsService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body){
			mocks.mockVoidMethod(this, 'notifyUsers', new List<Type>{String.class, Set<String>.class, String.class, String.class}, new List<Object>{targetId, recipientsIds, title, body});
		}
	}

	global class CustomNotificationTypesSelector extends fflib_SObjectMocks.SObjectSelector implements ICustomNotificationTypesSelector{
		private fflib_ApexMocks mocks;

		global CustomNotificationTypesSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global CustomNotificationType selectByDeveloperName(String developerName){
			return (CustomNotificationType)mocks.mockNonVoidMethod(this, 'selectByDeveloperName', new List<Type>{String.class}, new List<Object>{developerName});
		}
	}

	global class DatabaseService implements IDatabaseService{
		private fflib_ApexMocks mocks;

		global DatabaseService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global Id executeBatch(Database.Batchable<SObject> batchableClass){
			return (Id)mocks.mockNonVoidMethod(this, 'executeBatch', new List<Type>{Database.Batchable<SObject>.class}, new List<Object>{batchableClass});
		}

		global Id executeBatch(Database.Batchable<SObject> batchableClass, Integer nbOfIteration){
			return (Id)mocks.mockNonVoidMethod(this, 'executeBatch', new List<Type>{Database.Batchable<SObject>.class, Integer.class}, new List<Object>{batchableClass, nbOfIteration});
		}

		global Id iterate(Database.Batchable<CustomIterator> iteratorClass, Integer nbOfIteration){
			return (Id)mocks.mockNonVoidMethod(this, 'iterate', new List<Type>{Database.Batchable<CustomIterator>.class, Integer.class}, new List<Object>{iteratorClass, nbOfIteration});
		}
	}

	global class DatacloudService implements IDatacloudService{
		private fflib_ApexMocks mocks;

		global DatacloudService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global List<SObject> findDuplicates(SObject record){
			return (List<SObject>)mocks.mockNonVoidMethod(this, 'findDuplicates', new List<Type>{SObject.class}, new List<Object>{record});
		}
	}

	global class EmailTemplatesService implements IEmailTemplatesService{
		private fflib_ApexMocks mocks;

		global EmailTemplatesService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
			return (String)mocks.mockNonVoidMethod(this, 'replaceFieldReferencesByValue', new List<Type>{String.class, List<SObject>.class}, new List<Object>{content, sObjects});
		}
	}

	global class FeatureManagementService implements IFeatureManagementService{
		private fflib_ApexMocks mocks;

		global FeatureManagementService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global Boolean checkPermission(String permissionName){
			return (Boolean)mocks.mockNonVoidMethod(this, 'checkPermission', new List<Type>{String.class}, new List<Object>{permissionName});
		}

		global Boolean bypassChatterNotification(){
			return (Boolean)mocks.mockNonVoidMethod(this, 'bypassChatterNotification', new List<Type>{}, new List<Object>{});
		}

		global Boolean bypassValidationRules(){
			return (Boolean)mocks.mockNonVoidMethod(this, 'bypassValidationRules', new List<Type>{}, new List<Object>{});
		}
	}

	global class MessagingService implements IMessagingService{
		private fflib_ApexMocks mocks;

		global MessagingService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
			return (Messaging.EmailFileAttachment)mocks.mockNonVoidMethod(this, 'prepareFileAttachment', new List<Type>{String.class, String.class}, new List<Object>{fileName, body});
		}

		global void newSingleEmailMessage(){
			mocks.mockVoidMethod(this, 'newSingleEmailMessage', new List<Type>{}, new List<Object>{});
		}

		global void setTargetObjectId(Id targetObjectId){
			mocks.mockVoidMethod(this, 'setTargetObjectId', new List<Type>{Id.class}, new List<Object>{targetObjectId});
		}

		global void setWhatId(Id whatId){
			mocks.mockVoidMethod(this, 'setWhatId', new List<Type>{Id.class}, new List<Object>{whatId});
		}

		global void setToAddress(String toAddress){
			mocks.mockVoidMethod(this, 'setToAddress', new List<Type>{String.class}, new List<Object>{toAddress});
		}

		global void setToAddresses(Set<String> toAddresses){
			mocks.mockVoidMethod(this, 'setToAddresses', new List<Type>{Set<String>.class}, new List<Object>{toAddresses});
		}

		global void setToAddresses(List<String> toAddresses){
			mocks.mockVoidMethod(this, 'setToAddresses', new List<Type>{List<String>.class}, new List<Object>{toAddresses});
		}

		global void setCcAddresses(List<String> ccAddresses){
			mocks.mockVoidMethod(this, 'setCcAddresses', new List<Type>{List<String>.class}, new List<Object>{ccAddresses});
		}

		global void setBccAddress(String bccAddress){
			mocks.mockVoidMethod(this, 'setBccAddress', new List<Type>{String.class}, new List<Object>{bccAddress});
		}

		global void setBccAddresses(List<String> bccAddresses){
			mocks.mockVoidMethod(this, 'setBccAddresses', new List<Type>{List<String>.class}, new List<Object>{bccAddresses});
		}

		global void setSubject(String subject){
			mocks.mockVoidMethod(this, 'setSubject', new List<Type>{String.class}, new List<Object>{subject});
		}

		global void setHtmlBody(String htmlBody){
			mocks.mockVoidMethod(this, 'setHtmlBody', new List<Type>{String.class}, new List<Object>{htmlBody});
		}

		global void setSaveAsActivity(Boolean saveAsActivity){
			mocks.mockVoidMethod(this, 'setSaveAsActivity', new List<Type>{Boolean.class}, new List<Object>{saveAsActivity});
		}

		global void setUseSignature(Boolean useSignature){
			mocks.mockVoidMethod(this, 'setUseSignature', new List<Type>{Boolean.class}, new List<Object>{useSignature});
		}

		global void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
			mocks.mockVoidMethod(this, 'setFileAttachments', new List<Type>{List<Messaging.EmailFileAttachment>.class}, new List<Object>{emailFileAttachments});
		}

		global void setSenderDisplayName(String senderDisplayName){
			mocks.mockVoidMethod(this, 'setSenderDisplayName', new List<Type>{String.class}, new List<Object>{senderDisplayName});
		}

		global void setReplyTo(String replyTo){
			mocks.mockVoidMethod(this, 'setReplyTo', new List<Type>{String.class}, new List<Object>{replyTo});
		}

		global List<Messaging.SendEmailResult> sendEmails(){
			return (List<Messaging.SendEmailResult>)mocks.mockNonVoidMethod(this, 'sendEmails', new List<Type>{}, new List<Object>{});
		}
	}

	global class OrganizationsSelector extends fflib_SObjectMocks.SObjectSelector implements IOrganizationsSelector{
		private fflib_ApexMocks mocks;

		global OrganizationsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global List<Organization> selectAll(){
			return (List<Organization>)mocks.mockNonVoidMethod(this, 'selectAll', new List<Type>(), new List<Object>());
		}
	}

	global class OrganizationsService implements IOrganizationsService{
		private fflib_ApexMocks mocks;

		global OrganizationsService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		global String retrieveOrganizationName(){
			return (String)mocks.mockNonVoidMethod(this, 'retrieveOrganizationName', new List<Type>(), new List<Object>());
		}
	}

	global class PermissionSetAssignmentsSelector extends fflib_SObjectMocks.SObjectSelector implements IPermissionSetAssignmentsSelector{
		private fflib_ApexMocks mocks;

		global PermissionSetAssignmentsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global Map<Id, List<PermissionSetAssignment>> mapByUserId(Set<Id> userIds){
			return (Map<Id, List<PermissionSetAssignment>>)mocks.mockNonVoidMethod(this, 'mapByUserId', new List<Type>{Set<Id>.class}, new List<Object>{userIds});
		}
	}

	global class PermissionSetsSelector extends fflib_SObjectMocks.SObjectSelector implements IPermissionSetsSelector{
		private fflib_ApexMocks mocks;

		global PermissionSetsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global Map<String, Id> mapIdByName(){
			return (Map<String, Id>)mocks.mockNonVoidMethod(this, 'mapIdByName', new List<Type>{}, new List<Object>{});
		}
	}

	global class UserRecordAccessesSelector extends fflib_SObjectMocks.SObjectSelector implements IUserRecordAccessesSelector{
		private fflib_ApexMocks mocks;

		global UserRecordAccessesSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global Boolean canEditRecord(Id userId, Id recordId){
			return (Boolean)mocks.mockNonVoidMethod(this, 'canEditRecord', new List<Type>{Id.class, Id.class}, new List<Object>{userId, recordId});
		}

		global Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds){
			return (Map<Id, Boolean>)mocks.mockNonVoidMethod(this, 'canEditRecords', new List<Type>{Id.class, Set<Id>.class}, new List<Object>{userId, recordIds});
		}
	}

	global class UsersSelector extends fflib_SObjectMocks.SObjectSelector implements IUsersSelector{
		private fflib_ApexMocks mocks;

		global UsersSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		global User selectById(Id userId){
			return (User)mocks.mockNonVoidMethod(this, 'selectById', new List<Type>{Id.class}, new List<Object>{userId});
		}

		global List<User> selectByIds(Set<Id> userIds){
			return (List<User>)mocks.mockNonVoidMethod(this, 'selectByIds', new List<Type>{Set<Id>.class}, new List<Object>{userIds});
		}
	}
}