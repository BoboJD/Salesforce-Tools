global inherited sharing virtual class ContentDocumentLinksHandler extends TriggerHandler{
	global List<ContentDocumentLink> contentDocumentLinks { get { return (List<ContentDocumentLink>)domain.Records; } }

	global ContentDocumentLinksHandler(tlz_ContentDocumentLinks domain){
		super(domain);
	}

	global ContentDocumentLinksHandler(tlz_ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}
}