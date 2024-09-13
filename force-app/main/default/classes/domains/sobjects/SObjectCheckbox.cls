global with sharing class SObjectCheckbox extends TriggerHandler{

	private SObjectCheckbox(fflib_SObjectDomain domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	private SObjectCheckbox(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}

	global static SObjectCheckbox handleInsert(fflib_SObjectDomain domain, fflib_ISObjectUnitOfWork uow){
		return new SObjectCheckbox(domain, uow);
	}

	global static SObjectCheckbox handleUpdate(fflib_SObjectDomain domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		return new SObjectCheckbox(domain, oldRecordById, uow);
	}

	global void uncheckField(SObjectField checkboxField){
		uncheckFields(new List<SObjectField>{checkboxField});
	}

	global void uncheckFields(List<SObjectField> checkboxFields){
		for(SObject record : domain.Records){
			SObject recordToUpdate = record.getSObjectType().newSObject(record.Id);
			List<SObjectField> checkboxFieldsToUncheck = new List<SObjectField>();
			for(SObjectField checkboxField : checkboxFields){
				if(checkboxFieldHasBeenChecked(record, checkboxField)){
					recordToUpdate.put(checkboxField, false);
					checkboxFieldsToUncheck.add(checkboxField);
				}
			}
			if(!checkboxFieldsToUncheck.isEmpty())
				uow.registerDirty(recordToUpdate, checkboxFieldsToUncheck);
		}
	}

	private Boolean checkboxFieldHasBeenChecked(SObject record, SObjectField checkboxField){
		Boolean isChecked = (Boolean)record.get(checkboxField);
		return isChecked && (isNew || hasChanged(record, checkboxField));
	}
}