@IsTest
public class Mocks{

	public class ConnectApiService implements IConnectApiService{
		private fflib_ApexMocks mocks;

		public ConnectApiService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public ConnectApi.FeedElement postFeedItemWithMentions(String communityId, String subjectId, String textWithMentions){
			return (ConnectApi.FeedElement)mocks.mockNonVoidMethod(this, 'postFeedItemWithMentions', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, subjectId, textWithMentions});
		}

		public ConnectApi.FeedElement postFeedItemWithRichText(String communityId, String subjectId, String textWithMentionsAndRichText){
			return (ConnectApi.FeedElement)mocks.mockNonVoidMethod(this, 'postFeedItemWithRichText', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, subjectId, textWithMentionsAndRichText});
		}

		public ConnectApi.Comment postCommentWithMentions(String communityId, String feedItemId, String textWithMentions){
			return (ConnectApi.Comment)mocks.mockNonVoidMethod(this, 'postCommentWithMentions', new List<Type>{String.class, String.class, String.class}, new List<Object>{communityId, feedItemId, textWithMentions});
		}

		public List<ConnectApi.MessageSegmentInput> getMessageSegmentInputs(String inputText){
			return (List<ConnectApi.MessageSegmentInput>)mocks.mockNonVoidMethod(this, 'getMessageSegmentInputs', new List<Type>{String.class}, new List<Object>{inputText});
		}

		public ConnectApi.MessageBodyInput createInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.MessageBodyInput)mocks.mockNonVoidMethod(this, 'createInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}

		public ConnectApi.FeedItemInput createFeedItemInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.FeedItemInput)mocks.mockNonVoidMethod(this, 'createFeedItemInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}

		public ConnectApi.CommentInput createCommentInputFromBody(ConnectApi.FeedBody body){
			return (ConnectApi.CommentInput)mocks.mockNonVoidMethod(this, 'createCommentInputFromBody', new List<Type>{ConnectApi.FeedBody.class}, new List<Object>{body});
		}
	}

	public class ContentDocumentLinksSelector extends fflib_SObjectMocks.SObjectSelector implements IContentDocumentLinksSelector{
		private fflib_ApexMocks mocks;

		public ContentDocumentLinksSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public List<ContentDocumentLink> selectByLinkedEntityIds(Set<Id> linkedEntityIds){
			return (List<ContentDocumentLink>)mocks.mockNonVoidMethod(this, 'selectByLinkedEntityIds', new List<Type>{Set<Id>.class}, new List<Object>{linkedEntityIds});
		}

		public Map<Id, List<ContentDocumentLink>> mapByContentDocumentId(Set<Id> contentDocumentIds){
			return (Map<Id, List<ContentDocumentLink>>)mocks.mockNonVoidMethod(this, 'mapByContentDocumentId', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	public class ContentDocumentsSelector extends fflib_SObjectMocks.SObjectSelector implements IContentDocumentsSelector{
		private fflib_ApexMocks mocks;

		public ContentDocumentsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public List<ContentDocument> selectByIds(Set<Id> contentDocumentIds){
			return (List<ContentDocument>)mocks.mockNonVoidMethod(this, 'selectByIds', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	public class ContentVersionsSelector extends fflib_SObjectMocks.SObjectSelector implements IContentVersionsSelector{
		private fflib_ApexMocks mocks;

		public ContentVersionsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public List<ContentVersion> selectLatestByContentDocumentIds(Set<Id> contentDocumentIds){
			return (List<ContentVersion>)mocks.mockNonVoidMethod(this, 'selectLatestByContentDocumentIds', new List<Type>{Set<Id>.class}, new List<Object>{contentDocumentIds});
		}
	}

	public class CustomNotificationsService implements ICustomNotificationsService{
		private fflib_ApexMocks mocks;

		public CustomNotificationsService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public void notifyUsers(String targetId, Set<String> recipientsIds, String title, String body){
			mocks.mockVoidMethod(this, 'notifyUsers', new List<Type>{String.class, Set<String>.class, String.class, String.class}, new List<Object>{targetId, recipientsIds, title, body});
		}
	}

	public class CustomNotificationTypesSelector extends fflib_SObjectMocks.SObjectSelector implements ICustomNotificationTypesSelector{
		private fflib_ApexMocks mocks;

		public CustomNotificationTypesSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public CustomNotificationType selectByDeveloperName(String developerName){
			return (CustomNotificationType)mocks.mockNonVoidMethod(this, 'selectByDeveloperName', new List<Type>{String.class}, new List<Object>{developerName});
		}
	}

	public class DatabaseService implements IDatabaseService{
		private fflib_ApexMocks mocks;

		public DatabaseService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public Id executeBatch(Database.Batchable<SObject> batchClassObject){
			return (Id)mocks.mockNonVoidMethod(this, 'executeBatch', new List<Type>{Database.Batchable<SObject>.class}, new List<Object>{batchClassObject});
		}

		public Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration){
			return (Id)mocks.mockNonVoidMethod(this, 'executeBatch', new List<Type>{Database.Batchable<SObject>.class, Integer.class}, new List<Object>{batchClassObject, nbOfIteration});
		}
	}

	public class DatacloudService implements IDatacloudService{
		private fflib_ApexMocks mocks;

		public DatacloudService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public List<SObject> findDuplicates(SObject record){
			return (List<SObject>)mocks.mockNonVoidMethod(this, 'findDuplicates', new List<Type>{SObject.class}, new List<Object>{record});
		}
	}

	public class EmailTemplatesService implements IEmailTemplatesService{
		private fflib_ApexMocks mocks;

		public EmailTemplatesService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public String replaceFieldReferencesByValue(String content, List<SObject> sObjects){
			return (String)mocks.mockNonVoidMethod(this, 'replaceFieldReferencesByValue', new List<Type>{String.class, List<SObject>.class}, new List<Object>{content, sObjects});
		}
	}

	public class FeatureManagementService implements IFeatureManagementService{
		private fflib_ApexMocks mocks;

		public FeatureManagementService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public Boolean checkPermission(String permissionName){
			return (Boolean)mocks.mockNonVoidMethod(this, 'checkPermission', new List<Type>{String.class}, new List<Object>{permissionName});
		}
	}

	public class MessagingService implements IMessagingService{
		private fflib_ApexMocks mocks;

		public MessagingService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
			return (Messaging.EmailFileAttachment)mocks.mockNonVoidMethod(this, 'prepareFileAttachment', new List<Type>{String.class, String.class}, new List<Object>{fileName, body});
		}

		public void newSingleEmailMessage(){
			mocks.mockVoidMethod(this, 'newSingleEmailMessage', new List<Type>{}, new List<Object>{});
		}

		public void setTargetObjectId(Id targetObjectId){
			mocks.mockVoidMethod(this, 'setTargetObjectId', new List<Type>{Id.class}, new List<Object>{targetObjectId});
		}

		public void setWhatId(Id whatId){
			mocks.mockVoidMethod(this, 'setWhatId', new List<Type>{Id.class}, new List<Object>{whatId});
		}

		public void setToAddress(String toAddress){
			mocks.mockVoidMethod(this, 'setToAddress', new List<Type>{String.class}, new List<Object>{toAddress});
		}

		public void setToAddresses(Set<String> toAddresses){
			mocks.mockVoidMethod(this, 'setToAddresses', new List<Type>{Set<String>.class}, new List<Object>{toAddresses});
		}

		public void setToAddresses(List<String> toAddresses){
			mocks.mockVoidMethod(this, 'setToAddresses', new List<Type>{List<String>.class}, new List<Object>{toAddresses});
		}

		public void setCcAddresses(List<String> ccAddresses){
			mocks.mockVoidMethod(this, 'setCcAddresses', new List<Type>{List<String>.class}, new List<Object>{ccAddresses});
		}

		public void setBccAddress(String bccAddress){
			mocks.mockVoidMethod(this, 'setBccAddress', new List<Type>{String.class}, new List<Object>{bccAddress});
		}

		public void setBccAddresses(List<String> bccAddresses){
			mocks.mockVoidMethod(this, 'setBccAddresses', new List<Type>{List<String>.class}, new List<Object>{bccAddresses});
		}

		public void setSubject(String subject){
			mocks.mockVoidMethod(this, 'setSubject', new List<Type>{String.class}, new List<Object>{subject});
		}

		public void setHtmlBody(String htmlBody){
			mocks.mockVoidMethod(this, 'setHtmlBody', new List<Type>{String.class}, new List<Object>{htmlBody});
		}

		public void setSaveAsActivity(Boolean saveAsActivity){
			mocks.mockVoidMethod(this, 'setSaveAsActivity', new List<Type>{Boolean.class}, new List<Object>{saveAsActivity});
		}

		public void setUseSignature(Boolean useSignature){
			mocks.mockVoidMethod(this, 'setUseSignature', new List<Type>{Boolean.class}, new List<Object>{useSignature});
		}

		public void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
			mocks.mockVoidMethod(this, 'setFileAttachments', new List<Type>{List<Messaging.EmailFileAttachment>.class}, new List<Object>{emailFileAttachments});
		}

		public void setSenderDisplayName(String senderDisplayName){
			mocks.mockVoidMethod(this, 'setSenderDisplayName', new List<Type>{String.class}, new List<Object>{senderDisplayName});
		}

		public void setReplyTo(String replyTo){
			mocks.mockVoidMethod(this, 'setReplyTo', new List<Type>{String.class}, new List<Object>{replyTo});
		}

		public List<Messaging.SendEmailResult> sendEmails(){
			return (List<Messaging.SendEmailResult>)mocks.mockNonVoidMethod(this, 'sendEmails', new List<Type>{}, new List<Object>{});
		}
	}

	public class OrganizationsSelector extends fflib_SObjectMocks.SObjectSelector implements IOrganizationsSelector{
		private fflib_ApexMocks mocks;

		public OrganizationsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public List<Organization> selectAll(){
			return (List<Organization>)mocks.mockNonVoidMethod(this, 'selectAll', new List<Type>(), new List<Object>());
		}
	}

	public class OrganizationsService implements IOrganizationsService{
		private fflib_ApexMocks mocks;

		public OrganizationsService(fflib_ApexMocks mocks){
			this.mocks = mocks;
		}

		public String retrieveOrganizationName(){
			return (String)mocks.mockNonVoidMethod(this, 'retrieveOrganizationName', new List<Type>(), new List<Object>());
		}
	}

	public class PermissionSetAssignmentsSelector extends fflib_SObjectMocks.SObjectSelector implements IPermissionSetAssignmentsSelector{
		private fflib_ApexMocks mocks;

		public PermissionSetAssignmentsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public Map<Id, List<PermissionSetAssignment>> mapByUserId(Set<Id> userIds){
			return (Map<Id, List<PermissionSetAssignment>>)mocks.mockNonVoidMethod(this, 'mapByUserId', new List<Type>{Set<Id>.class}, new List<Object>{userIds});
		}
	}

	public class PermissionSetsSelector extends fflib_SObjectMocks.SObjectSelector implements IPermissionSetsSelector{
		private fflib_ApexMocks mocks;

		public PermissionSetsSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public Map<String, Id> mapIdByName(){
			return (Map<String, Id>)mocks.mockNonVoidMethod(this, 'mapIdByName', new List<Type>{}, new List<Object>{});
		}
	}

	public class UserRecordAccessesSelector extends fflib_SObjectMocks.SObjectSelector implements IUserRecordAccessesSelector{
		private fflib_ApexMocks mocks;

		public UserRecordAccessesSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public Boolean canEditRecord(Id userId, Id recordId){
			return (Boolean)mocks.mockNonVoidMethod(this, 'canEditRecord', new List<Type>{Id.class, Id.class}, new List<Object>{userId, recordId});
		}

		public Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds){
			return (Map<Id, Boolean>)mocks.mockNonVoidMethod(this, 'canEditRecords', new List<Type>{Id.class, Set<Id>.class}, new List<Object>{userId, recordIds});
		}
	}

	public class UsersSelector extends fflib_SObjectMocks.SObjectSelector implements IUsersSelector{
		private fflib_ApexMocks mocks;

		public UsersSelector(fflib_ApexMocks mocks){
			super(mocks);
			this.mocks = mocks;
		}

		public User selectById(Id userId){
			return (User)mocks.mockNonVoidMethod(this, 'selectById', new List<Type>{Id.class}, new List<Object>{userId});
		}

		public List<User> selectByIds(Set<Id> userIds){
			return (List<User>)mocks.mockNonVoidMethod(this, 'selectByIds', new List<Type>{Set<Id>.class}, new List<Object>{userIds});
		}
	}
}