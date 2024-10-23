global interface tlz_IUserRecordAccessesSelector extends fflib_ISObjectSelector{
	Boolean canEditRecord(Id userId, Id recordId);
	Map<Id, Boolean> canEditRecords(Id userId, Set<Id> recordIds);
}