global inherited sharing class Users extends fflib_SObjectDomain implements IUsers{

	global Users(List<User> users){
		super(users);
	}

	global override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ PermissionSetAssignment.SObjectType });
		UserPermissionSet.handleInsert(this, uow).assignPermissionSets();
		uow.commitWork();
	}

	global override void onAfterUpdate(Map<Id, SObject> oldRecordById){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ PermissionSetAssignment.SObjectType });
		UserPermissionSet.handleUpdate(this, oldRecordById, uow).assignPermissionSets();
		uow.commitWork();
	}

	global class Constructor implements fflib_SObjectDomain.IConstructable{
		global fflib_SObjectDomain construct(List<SObject> sObjects){
			return new Users(sObjects);
		}
	}
}