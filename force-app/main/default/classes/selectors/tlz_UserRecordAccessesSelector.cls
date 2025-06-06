global inherited sharing class tlz_UserRecordAccessesSelector extends fflib_SObjectSelector implements tlz_IUserRecordAccessesSelector{

	global static tlz_IUserRecordAccessesSelector newInstance(){
		return (tlz_IUserRecordAccessesSelector)Application.Selector.newInstance(UserRecordAccess.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			UserRecordAccess.HasDeleteAccess,
			UserRecordAccess.HasEditAccess,
			UserRecordAccess.RecordId
		};
	}

	global override SObjectType getSObjectType(){
		return UserRecordAccess.SObjectType;
	}

	global Boolean canEditRecord(Id userId, Id recordId){
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

	global Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds){
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

	global Map<Id, Boolean> canDeleteRecords(Id userId, Set<Id> recordIds){
		Map<Id, Boolean> editRightByRecordId = new Map<Id, Boolean>();
		if(userId != null && !recordIds.isEmpty()){
			fflib_QueryFactory queryFactory = newQueryFactory()
				.setCondition('UserId = :userId AND RecordId IN :recordIds')
				.setOrdering(Schema.UserRecordAccess.RecordId, fflib_QueryFactory.SortOrder.ASCENDING);
			for(UserRecordAccess access : Database.query(queryFactory.toSOQL()))
				editRightByRecordId.put(access.RecordId, access.HasDeleteAccess);
		}
		return editRightByRecordId;
	}
}