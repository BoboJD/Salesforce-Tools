@IsTest
private class DmlManagerTest{

	@TestSetup
	static void setup(){
		UserBuilder.newChatterFreeUser().build();
	}

	@IsTest
	static void createAccountWithoutRightToInsertWhileAllowingPartialSuccessShouldLogError(){
		User chatterFreeUser = TestUtils.selectChatterFreeUser();
		System.runAs(chatterFreeUser){
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{Schema.Account.SObjectType}, DmlManager.allowPartialSuccess());
			uow.registerNew(AccountBuilder.newAccount().buildWithoutCommit());

			Test.startTest();
			String errorMessage;
			try{
				uow.commitWork();
			}catch(Exception e){
				errorMessage = e.getMessage();
			}
			Test.stopTest();

			Assert.isBlank(errorMessage);
			Assert.equals(1, LogFactory.instance().logs.size());
		}
	}

	@IsTest
	static void createAccountWithoutRightToInsertShouldThrowError(){
		User chatterFreeUser = TestUtils.selectChatterFreeUser();
		System.runAs(chatterFreeUser){
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{Schema.Account.SObjectType}, DmlManager.newInstance());
			uow.registerNew(AccountBuilder.newAccount().buildWithoutCommit());

			Test.startTest();
			String errorMessage;
			try{
				uow.commitWork();
			}catch(Exception e){
				errorMessage = e.getMessage();
			}
			Test.stopTest();

			Assert.isNotBlank(errorMessage);
			Assert.equals(0, LogFactory.instance().logs.size());
		}
	}

	@IsTest
	static void newInstanceWithDmlOptions(){
		Database.DMLOptions dmlOptions = new Database.DMLOptions();
		DmlManager dmlManager = DmlManager.newInstance(dmlOptions);
		Assert.equals(dmlOptions, dmlManager.dmlOptions);
	}

	@IsTest
	static void allowDuplicatesShouldAllowSave(){
		DmlManager dmlManager = DmlManager.allowDuplicates();
		Assert.isTrue(dmlManager.dmlOptions.DuplicateRuleHeader.allowSave);
	}
}