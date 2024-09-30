global with sharing class UserPermissionSet extends UsersHandler{

	private UserPermissionSet(Users domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	private UserPermissionSet(Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}

	global static UserPermissionSet handleInsert(Users domain, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, uow);
	}

	global static UserPermissionSet handleUpdate(Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, oldRecordById, uow);
	}

	global void assignPermissionSets(){
		List<User> usersToProcess = new List<User>();
		for(User user : users){
			if(newCreationOrProfileHasChanged(user) || checkboxWithPermissionsHasBeenChecked(user))
				usersToProcess.add(user);
		}
		if(!usersToProcess.isEmpty())
			PermissionSetAttributionHelper.newInstance(usersToProcess, uow).assignPermissionSets();
	}

	private Boolean newCreationOrProfileHasChanged(User user){
		return user.ProfileId != null && (isNew || hasChanged(user, Schema.User.ProfileId));
	}

	private Boolean checkboxWithPermissionsHasBeenChecked(User user){
		for(String checkboxField : PermissionSetAttributionHelper.permissionSetsByCheckbox.keySet()){
			if((Boolean)user.get(checkboxField) && (isNew || hasChanged(user, checkboxField)))
				return true;
		}
		return false;
	}
}