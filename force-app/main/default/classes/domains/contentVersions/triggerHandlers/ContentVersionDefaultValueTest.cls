@IsTest
private class ContentVersionDefaultValueTest{

	@TestSetup
	static void setup(){
		UserBuilder.newStandardUser().build();
	}

	@IsTest
	static void createFileWithJSONShouldHaveFieldsValueFilled(){
		User standardUser = TestUtils.selectStandardUser();
		System.runAs(standardUser){
			String json = '{"Type__c":"Test"}';

			Test.startTest();
			ContentVersion cv = ContentVersionBuilder.newFile('Mandat').withJSON(json).build();
			Test.stopTest();

			ContentVersion cvAfter = [SELECT Type__c FROM ContentVersion WHERE Id = :cv.Id];
			Assert.equals('Test', cvAfter.Type__c);
		}
	}
}