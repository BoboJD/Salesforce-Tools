global inherited sharing virtual class TriggerHandler{
	protected fflib_SObjectDomain domain;
	private Map<Id, SObject> oldRecordById;
	protected fflib_ISObjectUnitOfWork uow;

	@TestVisible
	protected Boolean isNew{
		get{
			return Trigger.isInsert;
		}
	}

	@TestVisible
	protected Boolean isDeleted{
		get{
			return Trigger.isDelete;
		}
	}

	@TestVisible
	protected Set<Id> recordIds{
		get{
			if(recordIds == null)
				recordIds = new Map<Id, SObject>(domain.Records).keySet();
			return recordIds;
		}set;
	}

	@TestVisible
	protected TriggerHandler(){}

	@TestVisible
	protected TriggerHandler(fflib_SObjectDomain domain){
		this.domain = domain;
	}

	@TestVisible
	protected TriggerHandler(fflib_SObjectDomain domain, fflib_ISObjectUnitOfWork uow){
		this.domain = domain;
		this.uow = uow;
	}

	@TestVisible
	protected TriggerHandler(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById){
		this(domain);
		this.oldRecordById = oldRecordById;
	}

	@TestVisible
	protected TriggerHandler(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		this(domain, uow);
		this.oldRecordById = oldRecordById;
	}

	@TestVisible
	protected Boolean hasChanged(SObject record, SObjectField fieldToVerify){
		return hasChanged(record, new List<SObjectField>{fieldToVerify});
	}

	@TestVisible
	protected Boolean hasChanged(SObject record, String fieldToVerify){
		return hasChanged(record, new List<String>{fieldToVerify});
	}

	@TestVisible
	protected Boolean hasBeenFilled(SObject record, SObjectField fieldToVerify){
		return record.get(fieldToVerify) != null && (isNew || hasChanged(record, new List<SObjectField>{fieldToVerify}));
	}

	@TestVisible
	protected Boolean hasBeenRemoved(SObject record, SObjectField fieldToVerify){
		return record.get(fieldToVerify) == null && hasChanged(record, new List<SObjectField>{fieldToVerify});
	}

	protected Boolean hasChanged(SObject record, List<SObjectField> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	protected Boolean hasChanged(SObject record, List<String> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	@TestVisible
	protected Boolean hasChanged(SObject record, Set<SObjectField> fieldsToVerify){
		return SObjectUtils.fieldValueHasChanged(record, old(record), fieldsToVerify);
	}

	protected SObject old(SObject record){
		return oldRecordById?.get(record.Id);
	}

	@TestVisible
	protected Set<Id> setIds(SObjectField sObjectField){
		Set<Id> ids = new Set<Id>();
		for(SObject record : domain.Records){
			if(record.get(sObjectField) != null)
				ids.add((Id)record.get(sObjectField));
		}
		return ids;
	}
}