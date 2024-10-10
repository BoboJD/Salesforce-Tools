global with sharing class UserPermissionSet extends UsersHandler{

	private UserPermissionSet(tlz_Users domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	private UserPermissionSet(tlz_Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}

	global static UserPermissionSet handleInsert(tlz_Users domain, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, uow);
	}

	global static UserPermissionSet handleUpdate(tlz_Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		return new UserPermissionSet(domain, oldRecordById, uow);
	}

	global void assignPermissionSets(){
		List<User> usersToProcess = new List<User>();
		for(User user : users){
			if(newCreationOrProfileChangeOrActivationChange(user) || checkboxWithPermissionsHasBeenChecked(user))
				usersToProcess.add(user);
		}
		if(!usersToProcess.isEmpty())
			PermissionSetAttributionHelper.newInstance(usersToProcess, uow).assignPermissionSets();
	}

	private Boolean newCreationOrProfileChangeOrActivationChange(User user){
		return user.ProfileId != null
			&& (isNew || hasChanged(user, new List<SObjectField>{ Schema.User.ProfileId, Schema.User.IsActive }));
	}

	private Boolean checkboxWithPermissionsHasBeenChecked(User user){
		for(String checkboxField : PermissionSetAttributionHelper.permissionSetsByCheckbox.keySet()){
			if((Boolean)user.get(checkboxField) && (isNew || hasChanged(user, checkboxField)))
				return true;
		}
		return false;
	}
}