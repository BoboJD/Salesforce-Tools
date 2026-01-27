@IsTest
private class SoqlServiceControllerTest{

	@IsTest
	static void queryShouldReturnRecords(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.query('SELECT Id, Name FROM Account LIMIT 10');
		Test.stopTest();

		Assert.success(result);
		Assert.isNotNull(result.get('records'));
	}

	@IsTest
	static void queryShouldReturnErrorWithInvalidQuery(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.query('INVALID QUERY');
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void countQueryShouldReturnCount(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.countQuery('SELECT COUNT() FROM Account');
		Test.stopTest();

		Assert.success(result);
		Assert.isNotNull(result.get('count'));
	}

	@IsTest
	static void countQueryShouldReturnErrorWithInvalidQuery(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.countQuery('INVALID QUERY');
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void getSObjectListShouldReturnSObjects(){
		Test.startTest();
		List<Map<String, String>> sObjects = SoqlServiceController.getSObjectList();
		Test.stopTest();

		Assert.isNotNull(sObjects);
		Assert.isTrue(sObjects.size() > 0);
	}

	@IsTest
	static void getFieldsForSObjectShouldReturnFields(){
		Test.startTest();
		List<Map<String, Object>> fields = SoqlServiceController.getFieldsForSObject('Account');
		Test.stopTest();

		Assert.isNotNull(fields);
		Assert.isTrue(fields.size() > 0);
	}

	@IsTest
	static void getFieldsForSObjectShouldThrowExceptionWithInvalidSObject(){
		Test.startTest();
		try{
			SoqlServiceController.getFieldsForSObject('InvalidSObjectName');
			Assert.isTrue(false);
		}catch(AuraHandledException e){
			Assert.isNotNull(e.getMessage());
		}
		Test.stopTest();
	}

	@IsTest
	static void getFieldsForSObjectShouldThrowExceptionWithNullSObject(){
		Test.startTest();
		try{
			SoqlServiceController.getFieldsForSObject(null);
			Assert.isTrue(false);
		}catch(AuraHandledException e){
			Assert.isNotNull(e.getMessage());
		}
		Test.stopTest();
	}

	@IsTest
	static void getFieldsForSObjectShouldThrowExceptionWithEmptySObject(){
		Test.startTest();
		try{
			SoqlServiceController.getFieldsForSObject('');
			Assert.isTrue(false);
		}catch(AuraHandledException e){
			Assert.isNotNull(e.getMessage());
		}
		Test.stopTest();
	}

	@IsTest
	static void queryShouldReturnErrorWithNullQuery(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.query(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}

	@IsTest
	static void countQueryShouldReturnErrorWithNullQuery(){
		Test.startTest();
		Map<String, Object> result = SoqlServiceController.countQuery(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}
}
