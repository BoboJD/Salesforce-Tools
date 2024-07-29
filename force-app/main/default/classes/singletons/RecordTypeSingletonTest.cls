@IsTest
private class RecordTypeSingletonTest{

	@IsTest
	static void getRecordTypeShouldReturnRecordTypeInfo(){
		Test.startTest();
		Schema.RecordTypeInfo recordTypeInfo = RecordTypeSingleton.getRecordTypeInfo(Log__c.SObjectType, LogConstants.RT_ERROR);
		Test.stopTest();

		RecordType rtLogError = getErrorLogRecordType();
		Assert.equals(rtLogError.Id, recordTypeInfo.getRecordTypeId());
	}

	@IsTest
	static void getRecordTypeIdShouldReturnRecordTypeId(){
		Test.startTest();
		Id recordTypeId = RecordTypeSingleton.getRecordTypeId(Log__c.SObjectType, LogConstants.RT_ERROR);
		Test.stopTest();

		RecordType rtLogError = getErrorLogRecordType();
		Assert.equals(rtLogError.Id, recordTypeId);
	}

	static RecordType getErrorLogRecordType(){
		return [
			SELECT Id
			FROM RecordType
			WHERE SObjectType = :Log__c.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).getName()
			AND DeveloperName = :LogConstants.RT_ERROR
		];
	}
}