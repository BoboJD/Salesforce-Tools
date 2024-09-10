global inherited sharing virtual class TriggerHandler{
	global fflib_SObjectDomain domain;
	private Map<Id, SObject> oldRecordById;
	global fflib_ISObjectUnitOfWork uow;

	@TestVisible
	global Boolean isNew{
		get{
			return Trigger.isInsert;
		}
	}

	@TestVisible
	global Boolean isDeleted{
		get{
			return Trigger.isDelete;
		}
	}

	@TestVisible
	global Set<Id> recordIds{
		get{
			if(recordIds == null)
				recordIds = new Map<Id, SObject>(domain.Records).keySet();
			return recordIds;
		}set;
	}

	@TestVisible
	global TriggerHandler(){}

	@TestVisible
	global TriggerHandler(fflib_SObjectDomain domain){
		this.domain = domain;
	}

	@TestVisible
	global TriggerHandler(fflib_SObjectDomain domain, fflib_ISObjectUnitOfWork uow){
		this.domain = domain;
		this.uow = uow;
	}

	@TestVisible
	global TriggerHandler(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById){
		this(domain);
		this.oldRecordById = oldRecordById;
	}

	@TestVisible
	global TriggerHandler(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		this(domain, uow);
		this.oldRecordById = oldRecordById;
	}

	@TestVisible
	global Boolean hasChanged(SObject record, SObjectField fieldToVerify){
		return hasChanged(record, new List<SObjectField>{fieldToVerify});
	}

	@TestVisible
	global Boolean hasChanged(SObject record, String fieldToVerify){
		return hasChanged(record, new List<String>{fieldToVerify});
	}

	@TestVisible
	global Boolean hasBeenFilled(SObject record, SObjectField fieldToVerify){
		return record.get(fieldToVerify) != null && (isNew || hasChanged(record, new List<SObjectField>{fieldToVerify}));
	}

	@TestVisible
	global Boolean hasBeenRemoved(SObject record, SObjectField fieldToVerify){
		return record.get(fieldToVerify) == null && hasChanged(record, new List<SObjectField>{fieldToVerify});
	}

	global Boolean hasChanged(SObject record, List<SObjectField> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	global Boolean hasChanged(SObject record, List<String> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	@TestVisible
	global Boolean hasChanged(SObject record, Set<SObjectField> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	global SObject old(SObject record){
		return oldRecordById?.get(record.Id);
	}

	@TestVisible
	global Set<Id> setIds(SObjectField sObjectField){
		Set<Id> ids = new Set<Id>();
		for(SObject record : domain.Records){
			if(record.get(sObjectField) != null)
				ids.add((Id)record.get(sObjectField));
		}
		return ids;
	}
}