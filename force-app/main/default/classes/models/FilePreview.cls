public class FilePreview{
	@AuraEnabled public Id id;
	@AuraEnabled public Id documentId;
	@AuraEnabled public Id contentDocumentLinkId;
	@AuraEnabled public String title;
	@AuraEnabled public String type;
	@AuraEnabled public String createdDate;
	@AuraEnabled public Decimal size;
	@AuraEnabled public String sizeUnit;
	@AuraEnabled public String extension;
	@AuraEnabled public String previewLink;
	@AuraEnabled public Boolean selected;

	public FilePreview(ContentVersion contentVersion, Id contentDocumentLinkId){
		id = contentVersion.Id;
		documentId = contentVersion.ContentDocumentId;
		this.contentDocumentLinkId = contentDocumentLinkId;
		title = contentVersion.Title;
		type = SObjectFieldUtils.getLabelOfPicklistValue(contentVersion, Schema.ContentVersion.Type__c);
		createdDate = contentVersion.CreatedDate?.format('dd/MM/yyyy');
		initSize(contentVersion);
		extension = contentVersion.FileExtension?.toLowerCase();
		previewLink = hasPreview() ? '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB120BY90&versionId='+contentVersion.Id+'&operationContext=CHATTER&page=0' : null;
		selected = false;
	}

	private void initSize(ContentVersion contentVersion){
		size = contentVersion.ContentSize;
		sizeUnit = 'B';
		if(size > 1024){
			size = DecimalUtils.round(size / 1024, 0);
			sizeUnit = 'KB';
		}
		if(size > 1024){
			size = DecimalUtils.round(size / 1024, 0);
			sizeUnit = 'MB';
		}
	}

	private Boolean hasPreview(){
		Set<String> extensionWithPreview = new Set<String>{'txt', 'pdf', 'ppt', 'jpg', 'png', 'jpeg', 'gif'};
		return extensionWithPreview.contains(extension);
	}
}