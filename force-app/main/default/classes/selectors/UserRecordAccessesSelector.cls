public inherited sharing class UserRecordAccessesSelector extends fflib_SObjectSelector implements IUserRecordAccessesSelector{
	
	public static IUserRecordAccessesSelector newInstance(){
		return (IUserRecordAccessesSelector)Application.Selector.newInstance(UserRecordAccess.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			UserRecordAccess.HasEditAccess,
			UserRecordAccess.RecordId
		};
	}

	public SObjectType getSObjectType(){
		return UserRecordAccess.SObjectType;
	}

	public Boolean canEditRecord(Id userId, Id recordId){
		Boolean canEditRecord = false;
		if(userId != null && recordId != null){
			List<UserRecordAccess> accesses = Database.query(newQueryFactory()
				.setCondition('UserId = :userId AND RecordId = :recordId')
				.setOrdering(Schema.UserRecordAccess.RecordId, fflib_QueryFactory.SortOrder.ASCENDING)
				.toSOQL());
			canEditRecord = !accesses.isEmpty() && accesses[0].HasEditAccess;
		}
		return canEditRecord;
	}

	public Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds){
		Map<Id, Boolean> editRightByRecordId = new Map<Id, Boolean>();
		if(userId != null && !recordIds.isEmpty()){
			fflib_QueryFactory queryFactory = newQueryFactory()
				.setCondition('UserId = :userId AND RecordId IN :recordIds')
				.setOrdering(Schema.UserRecordAccess.RecordId, fflib_QueryFactory.SortOrder.ASCENDING);
			for(UserRecordAccess access : Database.query(queryFactory.toSOQL()))
				editRightByRecordId.put(access.RecordId, access.HasEditAccess);
		}
		return editRightByRecordId;
	}
}