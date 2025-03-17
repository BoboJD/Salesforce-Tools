public with sharing class ReportFileDownloaderController{

	@AuraEnabled
	public static Map<String, Object> getUtilityData(){
		Map<String, Object> utilityData = new Map<String, Object>();
		utilityData.put('fileTypes', SObjectFieldUtils.getPicklistValues(ContentVersion.tlz__FileType__c));
		utilityData.put('label', retrieveLabels());
		return utilityData;
	}

	private static Map<String, String> retrieveLabels(){
		return new Map<String, String>{
			'Report' => SObjectUtils.getLabel(Report.SObjectType),
			'Reports' => SObjectUtils.getLabelPlural(Report.SObjectType),
			'FileType' => SObjectFieldUtils.getLabel(ContentVersion.tlz__FileType__c)
		};
	}

	@AuraEnabled
	public static Map<String, Object> downloadReportFiles(String formJSON){
		Map<String, Object> result;
		try{
			Form form = (Form)JSON.deserialize(formJSON, Form.class);
			Set<Id> recordIds = getRecordIdsFromReport(form.reportId);
			Set<Id> fileIds = getLatestPublishedVersionIdsFromRecordIdsAndFileType(recordIds, form.fileType);
			result = ControllerUtils.success('fileIds', fileIds);
		}catch(Exception e){
			if(!ExceptionUtils.isCustom(e))
				LogFactory.commitError(ReportFileDownloaderController.class, 'downloadReportFiles', new List<Object>{ formJSON }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}

	private static Set<Id> getRecordIdsFromReport(Id reportId){
		Set<Id> recordIds = new Set<Id>();
		Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)Reports.ReportManager.runReport(reportId, true).getFactMap().get('T!T');
		if(factDetails.getRows().isEmpty())
			throw new CustomException(Label.TheReportHasNoRecords);
		if(!firstColumnIsAnIdentifier(factDetails))
			throw new CustomException(Label.TheRecordIdShouldBeTheFirstColumnOfYourReport);
		for(Integer i = 0; i < factDetails.getRows().size(); i++)
			recordIds.add((Id)factDetails.getRows()[i].getDataCells()[0].getValue());
		return recordIds;
	}

	private static Boolean firstColumnIsAnIdentifier(Reports.ReportFactWithDetails factDetails){
		return factDetails.getRows()[0].getDataCells()[0].getValue() instanceof Id;
	}

	private static Set<Id> getLatestPublishedVersionIdsFromRecordIdsAndFileType(Set<Id> recordIds, String fileType){
		Set<Id> fileIds = new Set<Id>();
		for(ContentDocumentLink cdl : retrieveContentDocumentLinks(recordIds, fileType))
			fileIds.add(cdl.ContentDocument.LatestPublishedVersionId);
		if(fileIds.isEmpty())
			throw new CustomException(Label.NoFilesWereFoundInTheRecordsRelatedToYourReport);
		return fileIds;
	}

	private static List<ContentDocumentLink> retrieveContentDocumentLinks(Set<Id> recordIds, String fileType){
		if(String.isNotBlank(fileType))
			return tlz_ContentDocumentLinksSelector.newInstance().selectByLinkedEntityIdsAndFileTypes(recordIds, new List<String>{ fileType });
		return tlz_ContentDocumentLinksSelector.newInstance().selectByLinkedEntityIds(recordIds);
	}

	public class Form{
		public Id reportId;
		public String fileType;

		@TestVisible
		private Form(){}
	}
}