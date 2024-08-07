public without sharing class OrgSettings{
	private static OrgSettings instance;
	private OrgSetting__mdt orgSetting;

	public enum Setting{
		TEST_URL,
		TEST_PASSWORD
	}

	private static final List<Setting> CRYPTED_FIELDS = new List<Setting>{
		Setting.TEST_PASSWORD
	};

	private static final Map<Setting, SObjectField> FIELD_BY_SETTING = new Map<Setting, SObjectField>{
		Setting.TEST_URL => OrgSetting__mdt.TestUrl__c,
		Setting.TEST_PASSWORD => OrgSetting__mdt.TestPassword__c
	};

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
		for(SObjectField sObjectField : FIELD_BY_SETTING.values())
			fields.add(sObjectField.getDescribe(FieldDescribeOptions.DEFAULT).getName());
		return 'SELECT Id, '+String.join(fields, ', ')
			+ ' FROM tlz__OrgSetting__mdt'
			+ ' WHERE DeveloperName = \''+organizationName+'\'';
	}

	public static String get(Setting setting){
		String value = (String)getInstance().orgSetting?.get(FIELD_BY_SETTING.get(setting));
		if(CRYPTED_FIELDS.contains(setting))
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