global inherited sharing virtual class ContentVersionsHandler extends TriggerHandler{
	global List<ContentVersion> contentVersions { get { return (List<ContentVersion>)domain.Records; } }

	global ContentVersionsHandler(tlz_ContentVersions domain){
		super(domain);
	}

	global ContentVersionsHandler(tlz_ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}
}