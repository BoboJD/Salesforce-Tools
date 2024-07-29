public inherited sharing virtual class UsersHandler extends TriggerHandler{
	protected List<User> users { get { return (List<User>)domain.Records; } }

	protected UsersHandler(Users domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	protected UsersHandler(Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}
}