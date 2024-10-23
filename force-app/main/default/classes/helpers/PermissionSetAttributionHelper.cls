global inherited sharing class PermissionSetAttributionHelper{
	private List<User> users;
	private fflib_ISObjectUnitOfWork uow;

	private Set<Id> userIds{
		get{
			if(userIds == null)
				userIds = new Map<Id, User>(users).keySet();
			return userIds;
		}set;
	}

	private Map<Id, User> userById{
		get{
			if(userById == null)
				userById = new Map<Id, User>(tlz_UsersSelector.newInstance().selectByIds(userIds));
			return userById;
		}set;
	}

	private Boolean isNew{
		get{
			return Trigger.isExecuting && Trigger.isInsert;
		}
	}

	private Map<Id, List<PermissionSetAssignment>> assignedPermissionSetsByUserId{
		get{
			if(assignedPermissionSetsByUserId == null)
				assignedPermissionSetsByUserId = tlz_PermissionSetAssignmentsSelector.newInstance().mapByUserId(userIds);
			return assignedPermissionSetsByUserId;
		}set;
	}

	private static Set<String> automaticallyAssignedPermissionSets{
		get{
			if(automaticallyAssignedPermissionSets == null){
				automaticallyAssignedPermissionSets = new Set<String>();
				for(PermissionSetConfiguration__mdt config : PermissionSetConfiguration__mdt.getAll().values())
					automaticallyAssignedPermissionSets.addAll(config.GrantedPermissions__c.split(';'));
			}
			return automaticallyAssignedPermissionSets;
		}set;
	}

	private static Map<String, List<String>> permissionSetsByProfileName{
		get{
			if(permissionSetsByProfileName == null){
				permissionSetsByProfileName = new Map<String, List<String>>();
				for(PermissionSetConfiguration__mdt config : PermissionSetConfiguration__mdt.getAll().values()){
					if(config.AttributionType__c != 'Checkbox')
						permissionSetsByProfileName.put(config.Label, config.GrantedPermissions__c.split(';'));
				}
			}
			return permissionSetsByProfileName;
		}set;
	}

	global static Map<String, List<String>> permissionSetsByCheckbox{
		get{
			if(permissionSetsByCheckbox == null){
				permissionSetsByCheckbox = new Map<String, List<String>>();
				for(PermissionSetConfiguration__mdt config : PermissionSetConfiguration__mdt.getAll().values()){
					if(config.AttributionType__c == 'Checkbox')
						permissionSetsByCheckbox.put(config.Label, config.GrantedPermissions__c.split(';'));
				}
			}
			return permissionSetsByCheckbox;
		}set;
	}

	private static Map<String, Id> permissionSetIdByName{
		get{
			if(permissionSetIdByName == null)
				permissionSetIdByName = tlz_PermissionSetsSelector.newInstance().mapIdByName();
			return permissionSetIdByName;
		}set;
	}

	private PermissionSetAttributionHelper(List<User> users, fflib_ISObjectUnitOfWork uow){
		this.users = users;
		this.uow = uow;
	}

	global static PermissionSetAttributionHelper newInstance(List<User> users, fflib_ISObjectUnitOfWork uow){
		return new PermissionSetAttributionHelper(users, uow);
	}

	global void assignPermissionSets(){
		for(Id userId : userIds){
			User user = userById.get(userId);
			List<String> permissionSetsToAssign = retrievePermissionSetsToAssign(user);
			if(user.IsActive && !permissionSetsToAssign.isEmpty())
				managePermissionSetAssignments(user, permissionSetsToAssign);
			else if(!isNew && assignedPermissionSetsByUserId.containsKey(user.Id))
				removeAllAutomaticallyAssignedPermissionSets(user);
		}
	}

	private List<String> retrievePermissionSetsToAssign(User user){
		List<String> permissionSetsToAssign = new List<String>();
		if(permissionSetsByProfileName.containsKey(user.Profile.Name))
			permissionSetsToAssign.addAll(permissionSetsByProfileName.get(user.Profile.Name));
		for(String checkboxField : permissionSetsByCheckbox.keySet()){
			if((Boolean)user.get(checkboxField))
				permissionSetsToAssign.addAll(permissionSetsByCheckbox.get(checkboxField));
		}
		return permissionSetsToAssign;
	}

	private void managePermissionSetAssignments(User user, List<String> permissionSetsToAssign){
		List<String> alreadyAssignedPermissionSetNames = new List<String>();
		for(PermissionSetAssignment permissionSetAssignment : assignedPermissionSetsByUserId.get(user.Id)){
			alreadyAssignedPermissionSetNames.add(permissionSetAssignment.PermissionSet.Name);
			if(isAutomaticallyAssigned(permissionSetAssignment) && needsToBeRemoved(permissionSetAssignment, permissionSetsToAssign))
				uow.registerDeleted(permissionSetAssignment);
		}
		for(String permissionSetName : permissionSetsToAssign){
			if(alreadyAssignedPermissionSetNames.contains(permissionSetName) || !permissionSetIdByName.containsKey(permissionSetName)) continue;
			uow.registerNew(new PermissionSetAssignment(
				AssigneeId = user.Id,
				PermissionSetId = permissionSetIdByName.get(permissionSetName)
			));
			alreadyAssignedPermissionSetNames.add(permissionSetName);
		}
	}

	private Boolean isAutomaticallyAssigned(PermissionSetAssignment permissionSetAssignment){
		return automaticallyAssignedPermissionSets.contains(permissionSetAssignment.PermissionSet.Name);
	}

	private Boolean needsToBeRemoved(PermissionSetAssignment permissionSetAssignment, List<String> permissionSetsToAssign){
		return permissionSetsToAssign == null || !permissionSetsToAssign.contains(permissionSetAssignment.PermissionSet.Name);
	}

	private void removeAllAutomaticallyAssignedPermissionSets(User user){
		for(PermissionSetAssignment permissionSetAssignment : assignedPermissionSetsByUserId.get(user.Id)){
			if(isAutomaticallyAssigned(permissionSetAssignment))
				uow.registerDeleted(permissionSetAssignment);
		}
	}
}