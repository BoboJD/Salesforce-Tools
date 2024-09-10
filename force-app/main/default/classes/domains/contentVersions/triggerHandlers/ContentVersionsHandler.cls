global inherited sharing virtual class ContentVersionsHandler extends TriggerHandler{
	global List<ContentVersion> contentVersions { get { return (List<ContentVersion>)domain.Records; } }

	global ContentVersionsHandler(ContentVersions domain){
		super(domain);
	}

	global ContentVersionsHandler(ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}
}