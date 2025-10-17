public without sharing class FileRecordIdUpdateJob implements Database.Batchable<SObject>{
	private List<Id> excludedFileIds = new List<Id>();
	private Boolean verifyAllRecords = false;

	private FileRecordIdUpdateJob(Boolean verifyAllRecords){
		for(WorkspaceFile__c workspaceFile : [SELECT ContentDocumentId__c FROM WorkspaceFile__c LIMIT 2000]) excludedFileIds.add(workspaceFile.ContentDocumentId__c);
		this.verifyAllRecords = verifyAllRecords;
	}

	public static FileRecordIdUpdateJob instanceForNewRecords(){
		return new FileRecordIdUpdateJob(false);
	}

	public static FileRecordIdUpdateJob instanceForAllRecords(){
		return new FileRecordIdUpdateJob(true);
	}

	public Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator(constructSoqlQuery());
	}

	private String constructSoqlQuery(){
		String soql = 'SELECT Id, ContentDocumentId'
			+ ' FROM ContentVersion'
			+ ' WHERE IsLatest = true'
			+ ' AND (LastCheckOfRelationship__c < LAST_MONTH OR LastCheckOfRelationship__c  = null)'
			+ ' AND Id NOT IN :excludedFileIds';
		if(!verifyAllRecords)
			soql += ' AND UnrelatedToRecords__c = false';
		return soql;
	}

	public void execute(Database.BatchableContext bc, List<ContentVersion> contentVersions){
		try{
			Set<Id> contentDocumentIds = new Set<Id>();
			for(ContentVersion cv : contentVersions)
				contentDocumentIds.add(cv.ContentDocumentId);
			Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = tlz_ContentDocumentLinksSelector.newInstance().mapByContentDocumentId(contentDocumentIds);
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{
				Schema.ContentVersion.SObjectType, Schema.WorkspaceFile__c.SObjectType
			}, DmlManager.allowPartialSuccess());
			for(ContentVersion cv : contentVersions){
				if(isRelatedToContentWorkspace(cv, contentDocumentLinksByContentDocumentId)){
					uow.registerNew(new WorkspaceFile__c(ContentDocumentId__c = cv.ContentDocumentId));
				}else{
					Id relatedToRecordId = findRelatedRecord(cv, contentDocumentLinksByContentDocumentId);
					uow.registerDirty(new ContentVersion(
						Id = cv.Id,
						LastCheckOfRelationship__c = DateUtils.now(),
						UnrelatedToRecords__c = relatedToRecordId == null,
						RecordId__c = relatedToRecordId
					));
				}
			}
			uow.commitWork();
		}catch(Exception e){
			LogFactory.instance().logError(FileRecordIdUpdateJob.class, 'execute', new List<Object>{contentVersions}, e);
		}
		LogFactory.instance().commitWork();
	}

	private Boolean isRelatedToContentWorkspace(ContentVersion cv, Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId){
		for(ContentDocumentLink cdl : contentDocumentLinksByContentDocumentId.get(cv.ContentDocumentId)){
			if(cdl.LinkedEntityId.getSObjectType() == ContentWorkspace.SObjectType)
				return true;
		}
		return false;
	}

	private Id findRelatedRecord(ContentVersion cv, Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId){
		for(ContentDocumentLink cdl : contentDocumentLinksByContentDocumentId.get(cv.ContentDocumentId)){
			if(cdl.LinkedEntityId.getSObjectType() != User.SObjectType)
				return cdl.LinkedEntityId;
		}
		return null;
	}

	public void finish(Database.BatchableContext bc){}
}