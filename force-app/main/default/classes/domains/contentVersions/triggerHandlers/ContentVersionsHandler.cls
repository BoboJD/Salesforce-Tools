public inherited sharing virtual class ContentVersionsHandler extends TriggerHandler{
	protected List<ContentVersion> contentVersions { get { return (List<ContentVersion>)domain.Records; } }

	protected ContentVersionsHandler(ContentVersions domain){
		super(domain);
	}

	protected ContentVersionsHandler(ContentVersions domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	protected ContentVersion old(ContentVersion contentVersion){
		return (ContentVersion)super.old(contentVersion);
	}
}