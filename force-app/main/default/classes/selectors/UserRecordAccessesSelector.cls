global inherited sharing class UserRecordAccessesSelector extends tlz.fflib_SObjectSelector implements IUserRecordAccessesSelector{

	global static IUserRecordAccessesSelector newInstance(){
		return (IUserRecordAccessesSelector)Application.Selector.newInstance(UserRecordAccess.SObjectType);
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
				.setOrdering(Schema.UserRecordAccess.RecordId, tlz.fflib_QueryFactory.SortOrder.ASCENDING)
				.toSOQL());
			canEditRecord = !accesses.isEmpty() && accesses[0].HasEditAccess;
		}
		return canEditRecord;
	}

	global Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds){
		Map<Id, Boolean> editRightByRecordId = new Map<Id, Boolean>();
		if(userId != null && !recordIds.isEmpty()){
			for(Set<Id> recChunk : chunkRecordIds(recordIds, 200))
				editRightByRecordId.putAll(queryAccess(userId, recChunk, Schema.UserRecordAccess.HasEditAccess));
		}
		return editRightByRecordId;
	}

	private List<Set<Id>> chunkRecordIds(Set<Id> recordIds, Integer chunkSize){
		List<Set<Id>> chunks = new List<Set<Id>>();
		Set<Id> chunk = new Set<Id>();
		for(Id recId : recordIds){
			chunk.add(recId);
			if(chunk.size() == chunkSize){
				chunks.add(chunk.clone());
				chunk.clear();
			}
		}
		if(!chunk.isEmpty())
			chunks.add(chunk);
		return chunks;
	}

	private Map<Id, Boolean> queryAccess(Id userId, Set<Id> recChunk, Schema.SObjectField accessField){
		Map<Id, Boolean> result = new Map<Id, Boolean>();
		tlz.fflib_QueryFactory queryFactory = newQueryFactory()
			.setCondition('UserId = :userId AND RecordId IN :recChunk')
			.setOrdering(Schema.UserRecordAccess.RecordId, tlz.fflib_QueryFactory.SortOrder.ASCENDING);
		for(UserRecordAccess access : Database.query(queryFactory.toSOQL()))
			result.put(access.RecordId, (Boolean)access.get(accessField));
		return result;
	}

	global Map<Id, Boolean> canDeleteRecords(Id userId, Set<Id> recordIds){
		Map<Id, Boolean> deleteRightByRecordId = new Map<Id, Boolean>();
		if(userId != null && !recordIds.isEmpty()){
			for(Set<Id> recChunk : chunkRecordIds(recordIds, 200))
				deleteRightByRecordId.putAll(queryAccess(userId, recChunk, Schema.UserRecordAccess.HasDeleteAccess));
		}
		return deleteRightByRecordId;
	}
}