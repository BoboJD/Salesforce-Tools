@IsTest
public class Mocks{

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