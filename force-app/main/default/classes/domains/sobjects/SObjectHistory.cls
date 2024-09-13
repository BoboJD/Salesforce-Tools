global with sharing class SObjectHistory extends TriggerHandler{

	private SObjectHistory(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}

	global static SObjectHistory handleUpdate(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		return new SObjectHistory(domain, oldRecordById, uow);
	}

	global void registerChanges(){
		registerChanges(null);
	}

	global void registerChanges(List<SObjectField> sObjectFields){
		for(SObject record : domain.Records){
			if(sObjectFields == null || sObjectFields.isEmpty() || hasChanged(record, sObjectFields)){
				uow.registerNew(new SObjectHistory__c(
					RecordId__c = record.Id,
					SObject__c = record.Id.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED).getName(),
					Before__c = JSON.serialize(old(record)),
					After__c = JSON.serialize(record)
				));
			}
		}
	}
}