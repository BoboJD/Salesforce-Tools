@IsTest
private class LogFactoryTest{

	@IsTest
	static void instanceIsNotNull(){
		Test.startTest();
		LogFactory instance = LogFactory.instance();
		Test.stopTest();

		Assert.isNotNull(instance);
	}

	@IsTest
	static void logErrorShouldAddNewLog(){
		Test.startTest();
		LogFactory instance = LogFactory.instance().logError(LogFactoryTest.class, 'test', null, new CustomException());
		Test.stopTest();

		Assert.equals(1, instance.logs.size());
	}

	@IsTest
	static void logWebserviceErrorShouldAddNewLog(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://test.fr?id=toto');

		Test.startTest();
		LogFactory instance = LogFactory.instance().logWebserviceError(LogFactoryTest.class, req, new HttpResponse());
		Test.stopTest();

		Assert.equals(1, instance.logs.size());
	}

	@IsTest
	static void logErrorThenCommitWorkShouldCreateLog(){
		Test.startTest();
		LogFactory.instance().logError(LogFactoryTest.class, 'test', null, new CustomException()).commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}

	@IsTest
	static void logComponentErrorThenCommitWorkShouldCreateLog(){
		Test.startTest();
		LogFactory.instance().logComponentError('url', 'Large', 'component', 'method', 'details').commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}

	@IsTest
	static void logWebserviceResponseForHttpRequestAndResponseShouldAddNewLog(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://test.fr?id=toto');

		Test.startTest();
		LogFactory instance = LogFactory.instance().logWebserviceResponse(LogFactoryTest.class, req, new HttpResponse());
		Test.stopTest();

		Assert.equals(1, instance.logs.size());
	}

	@IsTest
	static void logWebserviceResponseShouldAddNewLog(){
		Test.startTest();
		LogFactory instance = LogFactory.instance().logWebserviceResponse(LogFactoryTest.class, 'endpoint', 'parameters', 'body');
		Test.stopTest();

		Assert.equals(1, instance.logs.size());
	}

	@IsTest
	static void logErrorWithIdParameterThenCommitWorkShouldCreateLog(){
		Test.startTest();
		LogFactory.instance().logError(LogFactoryTest.class, 'test', new List<Object>{UserInfo.getUserId()}, new CustomException()).commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}

	@IsTest
	static void logErrorWithSObjectParameterThenCommitWorkShouldCreateLog(){
		Test.startTest();
		LogFactory.instance().logError(LogFactoryTest.class, 'test', new List<Object>{new User()}, new CustomException()).commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}

	@IsTest
	static void logErrorWithParametersThenCommitWorkShouldCreateLog(){
		Test.startTest();
		LogFactory.instance().logError(LogFactoryTest.class, 'test', new List<Object>{new User(), UserInfo.getUserId(), 'test'}, new CustomException()).commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}

	@IsTest
	static void commitWorkShouldNotCreateLog(){
		Test.startTest();
		LogFactory.instance().commitWork();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(0, logs.size());
	}

	@IsTest
	static void commitErrorShouldCreateLog(){
		Test.startTest();
		LogFactory.commitError(LogFactoryTest.class, 'test', null, new CustomException());
		Test.stopTest();

		List<Log__c> logs = [SELECT Id FROM Log__c];
		Assert.equals(1, logs.size());
	}
}