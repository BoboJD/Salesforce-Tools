global inherited sharing virtual class UsersHandler extends TriggerHandler{
	global List<User> users { get { return (List<User>)domain.Records; } }

	global UsersHandler(tlz_Users domain, fflib_ISObjectUnitOfWork uow){
		super(domain, uow);
	}

	global UsersHandler(tlz_Users domain, Map<Id, SObject> oldRecordById, fflib_ISObjectUnitOfWork uow){
		super(domain, oldRecordById, uow);
	}
}