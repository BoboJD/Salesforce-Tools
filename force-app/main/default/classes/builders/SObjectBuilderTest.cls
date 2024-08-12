@IsTest
global class SObjectBuilderTest{

	@IsTest
	static void logBuilderShouldCreateRecord(){
		SObjectBuilder builder = new LogBuilder(LogConstants.RT_ERROR)
			.setFieldValue(Log__c.Type__c, LogConstants.TYPE_APEX)
			.setFieldValue('Message__c', 'message');

		Log__c recordWithoutId = (Log__c)builder.buildRecordWithoutCommit();
		Assert.isNull(recordWithoutId.Id);

		Log__c recordWithId = (Log__c)builder.buildRecord();
		Assert.isNotNull(recordWithId.Id);

		List<Log__c> logsCreated = (List<Log__c>)LogBuilder.build(new List<SObjectBuilder>{ builder });
		Assert.equals(1, logsCreated.size());
		Assert.isNotNull(logsCreated[0].Id);

		Map<String, SObject> logsCreatedMap = (Map<String, SObject>)LogBuilder.buildRecords(new Map<String, SObjectBuilder>{ 'log' => builder });
		Assert.equals(1, logsCreatedMap.size());
		Assert.isNotNull(logsCreatedMap.get('log')?.Id);
	}

	global class LogBuilder extends SObjectBuilder{

		global LogBuilder(){
			super();
		}

		global LogBuilder(String recordTypeDeveloperName){
			super(recordTypeDeveloperName);
		}

		global override SObjectType getSObjectType(){
			return Log__c.SObjectType;
		}
	}
}