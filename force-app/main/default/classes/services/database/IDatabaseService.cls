global interface IDatabaseService{
	Id executeBatch(Database.Batchable<SObject> batchableClass);
	Id executeBatch(Database.Batchable<SObject> batchableClass, Integer nbOfIteration);
	Id iterate(Database.Batchable<CustomIterator> iteratorClass, Integer nbOfIteration);
}