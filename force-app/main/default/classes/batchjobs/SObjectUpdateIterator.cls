global without sharing class SObjectUpdateIterator implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.StateFul{
	private List<SObject> records;
	private Integer nbOfErrors;

	private SObjectUpdateIterator(List<SObject> records){
		this.records = records;
		nbOfErrors = 0;
	}

	global static SObjectUpdateIterator newInstance(List<SObject> records){
		return new SObjectUpdateIterator(records);
	}

	global Iterable<SObject> start(Database.BatchableContext batchableContext){
		return (Iterable<SObject>)records;
	}

	global void execute(Database.BatchableContext batchableContext, List<SObject> records){
		handleSaveResults(Database.update(records, false));
	}

	private void handleSaveResults(Database.SaveResult[] saveResults){
		for(Database.SaveResult saveResult : saveResults) if(!saveResult.isSuccess()) nbOfErrors += 1;
	}

	global void finish(Database.BatchableContext batchableContext){
		Integer nbOfSuccess = records.size() - nbOfErrors;
		CustomNotificationsService.notifyUser(UserInfo.getUserId(), Label.SObjectUpdateIteratorTitle,
			String.format(Label.SObjectUpdateIteratorMessage, new List<Object>{ nbOfSuccess, nbOfErrors }));
	}
}