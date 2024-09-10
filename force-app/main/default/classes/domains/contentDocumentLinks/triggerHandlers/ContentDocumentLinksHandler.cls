global inherited sharing virtual class ContentDocumentLinksHandler extends TriggerHandler{
	global List<ContentDocumentLink> contentDocumentLinks { get { return (List<ContentDocumentLink>)domain.Records; } }

	global ContentDocumentLinksHandler(ContentDocumentLinks domain){
		super(domain);
	}

	global ContentDocumentLinksHandler(ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}
}