global class CurrentUser{
	private static CurrentUser instance;
	private User user;

	private CurrentUser(){
		user = UsersSelector.newInstance().selectById(UserInfo.getUserId());
	}

	private static CurrentUser getInstance(){
		if(instance == null) instance = new CurrentUser();
		return instance;
	}

	global static User data(){
		return getInstance().user;
	}

	global static Boolean isAdmin(){
		return data().Profile.Name == Label.ProfileSystemAdministrator || data().Admin__c;
	}

	global static Boolean canEditRecord(Id recordId){
		return UserRecordAccessesSelector.newInstance().canEditRecord(UserInfo.getUserId(), recordId);
	}

	global static Map<Id, Boolean> canEditRecords(Set<Id> recordIds){
		return UserRecordAccessesSelector.newInstance().canEditRecords(UserInfo.getUserId(), recordIds);
	}
}