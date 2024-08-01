public inherited sharing class DatabaseServiceImpl implements IDatabaseService{

	public Id executeBatch(Database.Batchable<SObject> batchClassObject){
		return Database.executeBatch(batchClassObject, 200);
	}

	public Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration){
		return Database.executeBatch(batchClassObject, nbOfIteration);
	}
}