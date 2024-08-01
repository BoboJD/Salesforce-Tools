public interface IDatabaseService{
	Id executeBatch(Database.Batchable<SObject> batchClassObject);
	Id executeBatch(Database.Batchable<SObject> batchClassObject, Integer nbOfIteration);
}