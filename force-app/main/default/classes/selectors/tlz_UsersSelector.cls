global inherited sharing class tlz_UsersSelector extends fflib_SObjectSelector implements tlz_IUsersSelector{
	private static List<User> allActiveUsers;

	global static tlz_IUsersSelector newInstance(){
		return (tlz_IUsersSelector)Application.Selector.newInstance(User.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			User.Id,
			User.Admin__c,
			User.IsActive
		};
	}

	global override SObjectType getSObjectType(){
		return User.SObjectType;
	}

	global User selectById(Id userId){
		User user = new User();
		if(userId != null){
			List<User> users = selectByIds(new Set<Id>{userId});
			if(!users.isEmpty())
				user = users[0];
		}
		return user;
	}

	global List<User> selectByIds(Set<Id> userIds){
		List<User> users = new List<User>();
		if(!userIds.isEmpty())
			users = Database.query(newQueryFactory()
				.selectField('Profile.Name')
				.selectFields(getAllCustomFields())
				.setCondition('Id IN :userIds')
				.toSOQL());
		return users;
	}

	private List<String> getAllCustomFields(){
		List<String> customFields = new List<String>();
		Map<String, SObjectField> fMap = Schema.User.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap();
		for(SObjectField ft : fMap.values()){
			if(getSObjectFieldList().contains(ft)) continue;
			String apiName = ft.getDescribe(FieldDescribeOptions.DEFAULT).getName();
			if(apiName.endsWith('__c'))
				customFields.add(apiName);
		}
		return customFields;
	}
}