global inherited sharing class UsersSelector extends fflib_SObjectSelector implements IUsersSelector{
	private static List<User> allActiveUsers;

	global static IUsersSelector newInstance(){
		return (IUsersSelector)Application.Selector.newInstance(User.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			User.Id,
			User.Admin__c
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
			users = Database.query(newQueryFactory().selectField('Profile.Name').setCondition('Id IN :userIds').toSOQL());
		return users;
	}
}