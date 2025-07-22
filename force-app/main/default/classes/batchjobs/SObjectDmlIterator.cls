global without sharing class SObjectDmlIterator implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.StateFul{
	private List<SObject> records;
	private String dmlType;
	private Boolean notifyCurrentUser;
	private Integer nbOfErrors;

	private SObjectDmlIterator(List<SObject> records, String dmlType, Boolean notifyCurrentUser){
		this.records = records;
		this.dmlType = dmlType;
		this.notifyCurrentUser = notifyCurrentUser;
		nbOfErrors = 0;
	}

	global static SObjectDmlIterator newInstance(List<SObject> records, String dmlType){
		return new SObjectDmlIterator(records, dmlType, true);
	}

	global static SObjectDmlIterator newInstanceWithoutNotification(List<SObject> records, String dmlType){
		return new SObjectDmlIterator(records, dmlType, false);
	}

	global Iterable<SObject> start(Database.BatchableContext batchableContext){
		return (Iterable<SObject>)records;
	}

	global void execute(Database.BatchableContext batchableContext, List<SObject> records){
		if(dmlType == 'delete')
			handleDeleteResults(Database.delete(records, false));
		else
			handleSaveResults(dmlType == 'insert' ? Database.insert(records, false) : Database.update(records, false));
	}

	private void handleDeleteResults(Database.DeleteResult[] deleteResults){
		for(Database.DeleteResult deleteResult : deleteResults) if(!deleteResult.isSuccess()) nbOfErrors += 1;
	}

	private void handleSaveResults(Database.SaveResult[] saveResults){
		for(Database.SaveResult saveResult : saveResults) if(!saveResult.isSuccess()) nbOfErrors += 1;
	}

	global void finish(Database.BatchableContext batchableContext){
		if(notifyCurrentUser){
			Integer nbOfSuccess = records.size() - nbOfErrors;
			CustomNotificationsService.notifyUser(UserInfo.getUserId(), Label.SObjectDmlIteratorTitle,
				String.format(Label.SObjectDmlIteratorMessage, new List<Object>{ nbOfSuccess, nbOfErrors }));
		}
	}
}