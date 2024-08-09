global inherited sharing class DatabaseServiceImpl implements IDatabaseService{

	global Id executeBatch(Database.Batchable<SObject> batchClassObject){
		return Database.executeBatch(batchClassObject, 200);
	}

	global Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration){
		return Database.executeBatch(batchClassObject, nbOfIteration);
	}
}