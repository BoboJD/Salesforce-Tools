global without sharing class UserPermissionSetJob implements Database.Batchable<SObject>{

	private UserPermissionSetJob(){}

	global static UserPermissionSetJob newInstance(){
		return new UserPermissionSetJob();
	}

	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator('SELECT Id FROM User' + (Test.isRunningTest() ? ' WHERE FirstName = \'Standard\' AND LastName = \'User\'' : ''));
	}

	global void execute(Database.BatchableContext bc, List<User> users){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ PermissionSetAssignment.SObjectType });
		PermissionSetAttributionHelper.newInstance(users, uow).assignPermissionSets();
		uow.commitWork();
	}

	global void finish(Database.BatchableContext bc){}
}