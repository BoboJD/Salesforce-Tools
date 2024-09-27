global inherited sharing class DatabaseService{

	global static Id executeBatch(Database.Batchable<SObject> batchClassObject){
		return service().executeBatch(batchClassObject);
	}

	global static Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration){
		return service().executeBatch(batchClassObject, nbOfIteration);
	}

	global static Id iterate(Database.Batchable<CustomIterator> iteratorClass, Integer nbOfIteration){
		return service().iterate(iteratorClass, nbOfIteration);
	}

	private static IDatabaseService service(){
		return (IDatabaseService)Application.Service.newInstance(IDatabaseService.class);
	}
}