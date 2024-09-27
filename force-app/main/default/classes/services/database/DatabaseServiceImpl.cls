global inherited sharing class DatabaseServiceImpl implements IDatabaseService{

	global Id executeBatch(Database.Batchable<SObject> batchableClass){
		return Database.executeBatch(batchableClass, 200);
	}

	global Id executeBatch(Database.Batchable<SObject> batchableClass, Integer nbOfIteration){
		return Database.executeBatch(batchableClass, nbOfIteration);
	}

	global Id iterate(Database.Batchable<CustomIterator> iteratorClass, Integer nbOfIteration){
		return Database.executeBatch(iteratorClass, nbOfIteration);
	}
}