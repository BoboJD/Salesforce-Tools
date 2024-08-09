global with sharing class ContentDocumentLinkShareType extends ContentDocumentLinksHandler{
	global static Map<Id, ContentDocument> storedContentDocumentById;

	private static List<String> sObjectsWithShareTypeI{
		get{
			if(sObjectsWithShareTypeI == null){
				sObjectsWithShareTypeI = new List<String>();
				for(FileTypeConfiguration__mdt config : FileTypeConfiguration__mdt.getAll().values())
					sObjectsWithShareTypeI.add(config.SObjectApiName__c);
			}
			return sObjectsWithShareTypeI;
		}set;
	}

	private Map<Id, ContentDocument> contentDocumentById{
		get{
			if(storedContentDocumentById == null)
				storedContentDocumentById = new Map<Id, ContentDocument>(ContentDocumentsSelector.newInstance().selectByIds(setIds(ContentDocumentLink.ContentDocumentId)));
			return storedContentDocumentById;
		}set;
	}

	private ContentDocumentLinkShareType(ContentDocumentLinks domain){
		super(domain);
	}

	global static ContentDocumentLinkShareType handleInsert(ContentDocumentLinks domain){
		return new ContentDocumentLinkShareType(domain);
	}

	global void setShareTypeIAndVisiblityAll(){
		for(ContentDocumentLink contentDocumentLink : contentDocumentLinks){
			if(isNotPrivate(contentDocumentLink) && shareTypeNeedsToBeSet(contentDocumentLink)){
				contentDocumentLink.ShareType = ContentDocumentLinkConstants.SHARETYPE_I;
				contentDocumentLink.Visibility = ContentDocumentLinkConstants.VISIBILITY_ALL;
			}
		}
	}

	private Boolean isNotPrivate(ContentDocumentLink contentDocumentLink){
		ContentDocument cd = contentDocumentById.get(contentDocumentLink.ContentDocumentId);
		return cd.SharingPrivacy != ContentDocumentConstants.SHARINGPRIVACY_PRIVATE;
	}

	private Boolean shareTypeNeedsToBeSet(ContentDocumentLink contentDocumentLink){
		if(contentDocumentLink.LinkedEntityId == null) return false;
		String sObjectTypeName = contentDocumentLink.LinkedEntityId.getSObjectType().getDescribe(SObjectDescribeOptions.DEFERRED).getName();
		return sObjectsWithShareTypeI.contains(sObjectTypeName);
	}
}