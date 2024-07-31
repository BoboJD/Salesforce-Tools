public with sharing class UserPermissionSet extends UsersHandler{
	private Set<Id> userIds = new Set<Id>();
	private static Set<String> automaticallyAssignedPermissionSets;

	private Map<Id, User> userById{
		get{
			if(userById == null)
				userById = new Map<Id, User>(UsersSelector.newInstance().selectByIds(userIds));
			return userById;
		}set;
	}

	private Map<Id, List<PermissionSetAssignment>> assignedPermissionSetsByUserId{
		get{
			if(assignedPermissionSetsByUserId == null)
				assignedPermissionSetsByUserId = PermissionSetAssignmentsSelector.newInstance().mapByUserId(userIds);
			return assignedPermissionSetsByUserId;
		}set;
	}

	private static Map<String, List<String>> permissionSetsByProfileName{
		get{
			if(permissionSetsByProfileName == null){
				automaticallyAssignedPermissionSets = new Set<String>();
				permissionSetsByProfileName = new Map<String, List<String>>();
				for(PermissionSetConfiguration__mdt config : PermissionSetConfiguration__mdt.getAll().values()){
					List<String> permissionSets = config.GrantedPermissions__c.split(';');
					permissionSetsByProfileName.put(config.Label, permissionSets);
					for(String permissionSetName : permissionSets)
						automaticallyAssignedPermissionSets.add(permissionSetName);
				}
			}
			return permissionSetsByProfileName;
		}set;
	}

	private static Map<String, Id> permissionSetIdByName{
		get{
			if(permissionSetIdByName == null)
				permissionSetIdByName = PermissionSetsSelector.newInstance().mapIdByName();
			return permissionSetIdByName;
		}set;
	}

	private UserPermissionSet(Users domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	private UserPermissionSet(Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}

	public static UserPermissionSet handleInsert(Users domain, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, uow);
	}

	public static UserPermissionSet handleUpdate(Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, oldRecordById, uow);
	}

	public void assignPermissionSets(){
		for(User user : getUsersWhereItsNewOrProfileHasChanged()){
			String profileName = userById.get(user.Id).Profile.Name;
			if(permissionSetsByProfileName.containsKey(profileName)){
				managePermissionSetAssignments(user, permissionSetsByProfileName.get(profileName));
			}else if(!isNew && assignedPermissionSetsByUserId.containsKey(user.Id)){
				removeAllAutomaticallyAssignedPermissionSets(user);
			}
		}
	}

	private List<User> getUsersWhereItsNewOrProfileHasChanged(){
		List<User> usersToProcess = new List<User>();
		for(User user : users){
			if(newCreationOrProfileHasChanged(user)){
				usersToProcess.add(user);
				userIds.add(user.Id);
			}
		}
		return usersToProcess;
	}

	private Boolean newCreationOrProfileHasChanged(User user){
		return user.ProfileId != null && (isNew || hasChanged(user, Schema.User.ProfileId));
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