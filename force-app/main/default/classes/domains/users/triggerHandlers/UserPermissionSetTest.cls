@IsTest
private class UserPermissionSetTest{

	@IsTest
	static void createStandardUserShouldHavePermissionSetsAssigned(){
		Test.startTest();
		User standardUser = UserBuilder.newStandardUser().build();
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

	@IsTest
	static void updateStandardUserToContractManagerShouldHavePermissionSetRemoved(){
		Profile newProfile = [SELECT Id FROM Profile WHERE Name = :ProfileConstants.CONTRACT_MANAGER LIMIT 1];
		User standardUser = UserBuilder.newStandardUser().build();

		Test.startTest();
		update new User(
			Id = standardUser.Id,
			ProfileId = newProfile.Id
		);
		Test.stopTest();

		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(standardUser);
		Assert.equals(1, assignedPermissionSets.size());
	}

	@IsTest
	static void deactivateStandardUserShouldHaveAllPermissionSetsRemoved(){
		User standardUser = UserBuilder.newStandardUser().build();

		Test.startTest();
		update new User(
			Id = standardUser.Id,
			IsActive = false
		);
		Test.stopTest();

		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(standardUser);
		Assert.isEmpty(assignedPermissionSets);
	}

	@IsTest
	static void updateStandardUserToUnknownProfileShouldHaveAllPermissionSetRemoved(){
		Profile newProfile = [SELECT Id FROM Profile WHERE Name = :ProfileConstants.MARKETING_USER LIMIT 1];
		User standardUser = UserBuilder.newStandardUser().build();

		Test.startTest();
		update new User(
			Id = standardUser.Id,
			ProfileId = newProfile.Id
		);
		Test.stopTest();

		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(standardUser);
		Assert.equals(0, assignedPermissionSets.size());
	}

	@IsTest
	static void updateMarketingByCheckingTrackedCheckboxShouldHaveAdditionnalPermissionSetsAssigned(){
		User marketingUser = UserBuilder.newMarketingUser().build();

		Test.startTest();
		update new User(
			Id = marketingUser.Id,
			PermissionSetAttributionTest__c = true
		);
		Test.stopTest();

		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(marketingUser);
		Assert.equals(1, assignedPermissionSets.size());
	}

	@IsTest
	static void updateMarketingUserByCheckingUntrackedCheckboxShouldNotHaveAdditionnalPermissionSetsAssigned(){
		User marketingUser = UserBuilder.newMarketingUser().build();

		Test.startTest();
		update new User(
			Id = marketingUser.Id,
			UserPermissionsMarketingUser = true
		);
		Test.stopTest();

		List<PermissionSetAssignment> assignedPermissionSets = getAssignedPermissionSets(marketingUser);
		Assert.equals(0, assignedPermissionSets.size());
	}
}