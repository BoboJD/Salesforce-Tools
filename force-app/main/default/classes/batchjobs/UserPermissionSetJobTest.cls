@IsTest
private class UserPermissionSetJobTest{

	@IsTest
	static void runBatchOnStandardUserShouldHavePermissionSetsAssigned(){
		User standardUser = UserBuilder.newStandardUser().build();
		delete getAssignedPermissionSets(standardUser);
		Test.startTest();
		Database.executeBatch(UserPermissionSetJob.newInstance());
		Test.stopTest();
		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(standardUser);
		Assert.equals(2, assignedPermissionSets.size());
	}

	static List<PermissionSetAssignment> getAssignedPermissionSets(User user){
		return [
			SELECT Id
			FROM PermissionSetAssignment
			WHERE AssigneeId = :user.Id
			AND (PermissionSet.Name = 'ToolsUser' OR PermissionSet.Name = 'ToolsAdmin')
		];
	}
}