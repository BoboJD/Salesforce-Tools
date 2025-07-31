public with sharing class RecordHistoryController{

	@AuraEnabled(cacheable=true)
	public static List<SObjectHistory__c> getHistory(Id recordId) {
		return [
			SELECT Id, Name, CreatedById, CreatedByName__c, CreatedDate
			FROM SObjectHistory__c
			WHERE RecordId__c = :recordId
			WITH SECURITY_ENFORCED
			ORDER BY CreatedDate DESC
		];
	}
}