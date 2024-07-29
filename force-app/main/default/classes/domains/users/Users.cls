public inherited sharing class Users extends fflib_SObjectDomain implements IUsers{

	public Users(List<User> users){
		super(users);
	}

	public override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ PermissionSetAssignment.SObjectType });
		UserPermissionSet.handleInsert(this, uow).assignPermissionSets();
		uow.commitWork();
	}

	public override void onAfterUpdate(Map<Id, SObject> oldRecordById){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ PermissionSetAssignment.SObjectType });
		UserPermissionSet.handleUpdate(this, oldRecordById, uow).assignPermissionSets();
		uow.commitWork();
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjects){
			return new Users(sObjects);
		}
	}
}