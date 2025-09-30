@IsTest
global class TestUtils{
	private static final String CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

	private static LeadStatus leadConvertedStatus{
		get{
			if(leadConvertedStatus == null)
				leadConvertedStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
			return leadConvertedStatus;
		}set;
	}

	global static void setMock(HttpCalloutMock theMock){
		Test.setMock(HttpCalloutMock.class, theMock);
	}

	global static void setHttpResponse(String contentType, Integer statusCode, String body){
		Test.setMock(HttpCalloutMock.class, MockHttpResponseGenerator.initStringResponse(contentType, statusCode, body));
	}

	global static SObject setReadableFields(SObject sObj, Map<SObjectField, Object> valueBysObjField){
		Map<String,Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
		for(SObjectField field : valueBysObjField.keySet()){
			String fieldName = field.getDescribe(FieldDescribeOptions.DEFAULT).getName();
			dataMap.put(fieldName, valueBysObjField.get(field));
		}
		return (SObject)JSON.deserialize(JSON.serialize(dataMap), SObject.class);
	}

	global static SObject setReadableFields(SObject sObj, Map<String, Object> valueByFieldName){
		Map<String,Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(sObj));
		for(String fieldName : valueByFieldName.keySet()){
			Object value = valueByFieldName.get(fieldName);
			if(value instanceof List<SObject>){
				List<SObject> records = (List<SObject>)value;
				dataMap.put(fieldName, new Map<String, Object>{
					'totalSize' => records.size(),
					'done' => true,
					'records' => records
				});
			}else{
				dataMap.put(fieldName, value);
			}
		}
		return (SObject)JSON.deserialize(JSON.serialize(dataMap), SObject.class);
	}

	global static String generateUniqueName(){
		String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
		return dateString + randomInt;
	}

	global static String generateRandomString(Integer numberOfChars) {
		String randomString = '';
		while(randomString.length() < numberOfChars){
			Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), CHARS.length());
			randomString += CHARS.substring(index, index + 1);
		}
		return randomString;
	}

	global static void bypassValidationRules(User testUser){
		assignPermission(testUser, PermissionConstants.BYPASS_VALIDATION_RULES.removeStart('tlz__'));
	}

	global static void assignPermission(User testUser, String permissionSetName){
		PermissionSet permissionSetToAssign = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
		insert new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = permissionSetToAssign.Id);
	}

	global static Database.LeadConvertResult convertLead(Lead lead){
		return convertLead(lead, null);
	}

	global static Database.LeadConvertResult convertLead(Lead lead, Account account){
		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setLeadId(lead.Id);
		lc.setConvertedStatus(leadConvertedStatus.MasterLabel);
		if(account != null)
			lc.setAccountId(account.Id);
		return Database.convertLead(lc);
	}

	global static Account selectAccount(){
		return [SELECT Id FROM Account WHERE Name = 'TestAccount' LIMIT 1];
	}

	global static ContentVersion selectContentVersion(){
		return [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Title = 'TestFile' LIMIT 1];
	}

	global static User selectChatterFreeUser(){
		return [SELECT Id FROM User WHERE Name = 'Chatter Free User' LIMIT 1];
	}

	global static User selectStandardUser(){
		return [SELECT Id FROM User WHERE Name = 'Standard User' LIMIT 1];
	}
}