global without sharing class DmlManager extends fflib_SObjectUnitOfWork.SimpleDML{
	@TestVisible private Database.DMLOptions dmlOptions;

	private DmlManager(Database.DMLOptions dmlOptions){
		this.dmlOptions = dmlOptions;
	}

	global static DmlManager newInstance(){
		Database.DMLOptions dmlOptions = new Database.DMLOptions();
		dmlOptions.optAllOrNone = true;
		return new DmlManager(dmlOptions);
	}

	global static DmlManager newInstance(Database.DMLOptions dmlOptions){
		return new DmlManager(dmlOptions);
	}

	global static DmlManager allowDuplicates(){
		Database.DMLOptions dmlOptions = new Database.DMLOptions();
		dmlOptions.DuplicateRuleHeader.allowSave = true;
		return new DmlManager(dmlOptions);
	}

	global static DmlManager allowPartialSuccess(){
		Database.DMLOptions dmlOptions = new Database.DMLOptions();
		dmlOptions.optAllOrNone = false;
		return new DmlManager(dmlOptions);
	}

	global override void dmlInsert(List<SObject> sObjects){
		handleSaveResults(Database.insert(sObjects, dmlOptions));
	}

	private void handleSaveResults(Database.SaveResult[] saveResults){
		for(Database.SaveResult saveResult : saveResults) handleDatabaseErrors(saveResult.getErrors());
	}

	private void handleDatabaseErrors(List<Database.Error> errors){
		String message = '';
		for(Database.Error error : errors)
			message += error.getStatusCode() + ': ' + error.getMessage() + '\n';
		if(String.isNotBlank(message)){
			CustomException e = new CustomException(message);
			if(dmlOptions?.optAllOrNone == true || dmlOptions?.optAllOrNone == null)
				throw e;
			else
				LogFactory.instance().logError(DmlManager.class, 'handleDatabaseErrors', new List<Object>{}, e);
		}
	}

	global override void dmlUpdate(List<SObject> sObjects){
		handleSaveResults(Database.update(sObjects, dmlOptions));
	}

	global override void dmlDelete(List<SObject> sObjects){
		handleDeleteResults(Database.delete(sObjects));
	}

	private void handleDeleteResults(Database.DeleteResult[] deleteResults){
		for(Database.DeleteResult deleteResult : deleteResults) handleDatabaseErrors(deleteResult.getErrors());
	}
}