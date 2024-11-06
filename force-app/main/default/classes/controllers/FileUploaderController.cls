global with sharing class FileUploaderController{

	@AuraEnabled
	global static Map<String, Object> getUtilityData(Id recordId){
		Map<String, Object> utilityData = new Map<String, Object>();
		utilityData.put('files', getFiles(recordId));
		utilityData.put('fileTypes', SObjectFieldUtils.getPicklistValues(Schema.ContentVersion.FileType__c));
		utilityData.put('isAdmin', CurrentUser.isAdmin());
		utilityData.put('hasEditAccess', CurrentUser.canEditRecord(recordId));
		String sobjectApiName = recordId.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED).getName();
		utilityData.put('config', FileTypeConfiguration__mdt.getInstance(sobjectApiName.removeEnd('__c')));
		utilityData.put('sObjectType', sobjectApiName);
		return utilityData;
	}

	@AuraEnabled
	global static List<FilePreview> getFiles(Id recordId){
		Map<Id, Id> contentDocumentLinkIdByContentDocumentId = mapContentDocumentLinkIdByContentDocumentId(new Set<Id>{ recordId });
		Set<Id> contentDocumentIds = contentDocumentLinkIdByContentDocumentId.keySet();
		Map<Id, Boolean> hasDeleteAccessByContentDocumentId = CurrentUser.canDeleteRecords(contentDocumentIds);
		List<FilePreview> files = new List<FilePreview>();
		for(ContentVersion contentVersion : tlz_ContentVersionsSelector.newInstance().selectLatestByContentDocumentIds(contentDocumentIds)){
			Id contentDocumentLinkId = contentDocumentLinkIdByContentDocumentId.get(contentVersion.ContentDocumentId);
			Boolean hasDeleteAccess = hasDeleteAccessByContentDocumentId.get(contentVersion.ContentDocumentId);
			files.add(new FilePreview(contentVersion, contentDocumentLinkId, hasDeleteAccess));
		}
		return files;
	}

	private static Map<Id, Id> mapContentDocumentLinkIdByContentDocumentId(Set<Id> recordIds){
		Map<Id, Id> contentDocumentLinkIdByContentDocumentId = new Map<Id, Id>();
		for(ContentDocumentLink cdl : tlz_ContentDocumentLinksSelector.newInstance().selectByLinkedEntityIds(recordIds))
			contentDocumentLinkIdByContentDocumentId.put(cdl.ContentDocumentId, cdl.Id);
		return contentDocumentLinkIdByContentDocumentId;
	}

	@AuraEnabled
	global static Map<String, Object> deleteFiles(String filesToDeleteJSON){
		Map<String, Object> result = new Map<String, Object>();
		try{
			List<FilePreview> filePreviews = (List<FilePreview>)JSON.deserialize(filesToDeleteJSON, List<FilePreview>.class);
			Set<Id> contentDocumentIds = getContentDocumentIds(filePreviews);
			Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId = tlz_ContentDocumentLinksSelector.newInstance().mapByContentDocumentId(contentDocumentIds);
			if(!contentDocumentLinksByContentDocumentId.isEmpty()){
				fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ ContentDocument.SObjectType, ContentDocumentLink.SObjectType }, tlz.DmlManager.newInstance());
				for(FilePreview filePreview : filePreviews){
					if(fileIsRelatedToOtherSObject(filePreview, contentDocumentLinksByContentDocumentId) || !FilePreview.hasDeleteAccess)
						uow.registerDeleted(new ContentDocumentLink(Id = filePreview.contentDocumentLinkId));
					else
						uow.registerDeleted(new ContentDocument(Id = filePreview.documentId));
				}
				uow.commitWork();
			}
			result.put(Constants.STATUS, Constants.SUCCESS);
		}catch(Exception e){
			Boolean fileIsAlreadyDeleted = ExceptionUtils.isUnknown(e);
			if(fileIsAlreadyDeleted){
				result.put(Constants.STATUS, Constants.SUCCESS);
			}else{
				LogFactory.commitError(FileUploaderController.class, 'deleteFiles', new List<Object>{ filesToDeleteJSON }, e);
				result.put(Constants.STATUS, Constants.ERROR);
				result.put(Constants.MESSAGE, e.getMessage());
			}
		}
		return result;
	}

	private static Set<Id> getContentDocumentIds(List<FilePreview> filePreviews){
		Set<Id> contentDocumentIds = new Set<Id>();
		for(FilePreview filePreview : filePreviews)
			contentDocumentIds.add(filePreview.documentId);
		return contentDocumentIds;
	}

	private static Boolean fileIsRelatedToOtherSObject(FilePreview filePreview, Map<Id, List<ContentDocumentLink>> contentDocumentLinksByContentDocumentId){
		for(ContentDocumentLink cdl : contentDocumentLinksByContentDocumentId.get(filePreview.documentId)){
			if(cdl.LinkedEntityId.getSObjectType() == Schema.User.SObjectType || cdl.Id == filePreview.contentDocumentLinkId)
				continue;
			return true;
		}
		return false;
	}

	@AuraEnabled
	global static Map<String, Object> deleteFile(Id contentDocumentId){
		Map<String, Object> result = new Map<String, Object>();
		try{
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ ContentDocument.SObjectType });
			uow.registerDeleted(new ContentDocument(Id = contentDocumentId));
			uow.commitWork();
			result.put(Constants.STATUS, Constants.SUCCESS);
		}catch(Exception e){
			LogFactory.commitError(FileUploaderController.class, 'deleteFile', new List<Object>{ contentDocumentId }, e);
			result.put(Constants.STATUS, Constants.ERROR);
			result.put(Constants.MESSAGE, e.getMessage());
		}
		return result;
	}
}