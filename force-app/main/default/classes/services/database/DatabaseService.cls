public inherited sharing class DatabaseService{

	public static Id executeBatch(Database.Batchable<SObject> batchClassObject){
		return service().executeBatch(batchClassObject);
	}

	public static Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration){
		return service().executeBatch(batchClassObject, nbOfIteration);
	}

	private static IDatabaseService service(){
		return (IDatabaseService)Application.Service.newInstance(IDatabaseService.class);
	}
}