global inherited sharing virtual class ContentDocumentLinksHandler extends TriggerHandler{
	private static Map<Id, ContentDocument> storedContentDocumentById;
	global List<ContentDocumentLink> contentDocumentLinks { get { return (List<ContentDocumentLink>)domain.Records; } }

	global Map<Id, ContentDocument> contentDocumentById{
		get{
			if(storedContentDocumentById == null)
				storedContentDocumentById = new Map<Id, ContentDocument>(tlz_ContentDocumentsSelector.newInstance().selectByIds(setIds(ContentDocumentLink.ContentDocumentId)));
			return storedContentDocumentById;
		}set;
	}

	global ContentDocumentLinksHandler(tlz_ContentDocumentLinks domain){
		super(domain);
	}

	global ContentDocumentLinksHandler(tlz_ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	global static void resetStoredData(){
		storedContentDocumentById = null;
	}
}