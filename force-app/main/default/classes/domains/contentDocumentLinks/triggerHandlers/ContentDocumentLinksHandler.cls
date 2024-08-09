global inherited sharing virtual class ContentDocumentLinksHandler extends TriggerHandler{
	protected List<ContentDocumentLink> contentDocumentLinks { get { return (List<ContentDocumentLink>)domain.Records; } }

	protected ContentDocumentLinksHandler(ContentDocumentLinks domain){
		super(domain);
	}

	protected ContentDocumentLinksHandler(ContentDocumentLinks domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}
}