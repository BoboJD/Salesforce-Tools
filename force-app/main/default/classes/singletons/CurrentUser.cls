public class CurrentUser{
	private static CurrentUser instance;
	private User user;

	private CurrentUser(){
		user = UsersSelector.newInstance().selectById(UserInfo.getUserId());
	}

	private static CurrentUser getInstance(){
		if(instance == null) instance = new CurrentUser();
		return instance;
	}

	public static User data(){
		return getInstance().user;
	}

	public static Boolean isAdmin(){
		return data().Profile.Name == Label.ProfileSystemAdministrator || data().Admin__c;
	}

	public static Boolean canEditRecord(Id recordId){
		return UserRecordAccessesSelector.newInstance().canEditRecord(UserInfo.getUserId(), recordId);
	}

	public static Map<Id, Boolean> canEditRecords(Set<Id> recordIds){
		return UserRecordAccessesSelector.newInstance().canEditRecords(UserInfo.getUserId(), recordIds);
	}
}