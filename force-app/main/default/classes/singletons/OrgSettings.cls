global without sharing class OrgSettings{
	private static OrgSettings instance;
	private OrgSetting__mdt orgSetting;

	private OrgSettings(){
		orgSetting = retrieveOrgSettingFromOrgName();
	}

	private OrgSetting__mdt retrieveOrgSettingFromOrgName(){
		String organizationName = OrganizationsService.retrieveOrganizationName();
		List<OrgSetting__mdt> orgSettings = Database.query(constructSoqlQuery(organizationName));
		if(orgSettings.isEmpty())
			throw new OrgSettingsException('OrgSettings metadata record missing for org '+organizationName);
		return orgSettings[0];
	}

	private String constructSoqlQuery(String organizationName){
		List<String> fields = new List<String>();
		for(SObjectField sObjectField : OrgSetting__mdt.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap().values())
			fields.add(sObjectField.getDescribe(FieldDescribeOptions.DEFAULT).getName());
		return 'SELECT '+String.join(fields, ', ')
			+ ' FROM tlz__OrgSetting__mdt'
			+ ' WHERE DeveloperName = \''+organizationName+'\'';
	}

	global static String get(SObjectField sObjectField){
		return get(sObjectField, false);
	}

	global static String decrypt(SObjectField sObjectField){
		return get(sObjectField, true);
	}

	private static String get(SObjectField sObjectField, Boolean isCrypted){
		String value = (String)getInstance().orgSetting?.get(sObjectField);
		if(isCrypted)
			return decrypt(value);
		return value;
	}

	private static String decrypt(String encryptedValueString){
		Blob encryptionKey = getEncryptionKey();
		Blob decryptedString;
		try{
			Blob encryptedValue = EncodingUtil.base64Decode(encryptedValueString);
			decryptedString = Crypto.decryptWithManagedIV('AES256', encryptionKey, encryptedValue);
		}catch(Exception e){
			if(Test.isRunningTest())
				decryptedString = Blob.valueOf('FakePasswordFromException');
		}
		return decryptedString.toString();
	}

	private static Blob getEncryptionKey(){
		EncryptionKey__c encryptionKeyRecord = EncryptionKey__c.getOrgDefaults();
		String encryptionKeyString = String.isNotBlank(encryptionKeyRecord.Value__c) ? encryptionKeyRecord.Value__c
			: Test.isRunningTest() ? 'tzvs9mV7CVW2We8ZAd1hSeEBPGzqzyOGC981Ik7Z6do=' : null;
		return EncodingUtil.base64Decode(encryptionKeyString);
	}

	private static OrgSettings getInstance(){
		if(instance == null)
			instance = new OrgSettings();
		return instance;
	}

	@TestVisible
	private static void reset(){
		instance = null;
	}

	private class OrgSettingsException extends Exception{}
}