@IsTest
private class SettingsTest{

	@IsTest
	static void getSettingsNameShouldReturnDefault(){
		insert new Setting__c(Name = 'Default');
		Assert.equals('Default', Settings.get(Setting__c.Name));
		Assert.equals('Default', Settings.get('Name'));
	}

	@IsTest
	static void getValuesShouldReturnList(){
		insert new Setting__c(Name = 'Default');
		Assert.equals(new List<String>{'Default'}, Settings.getValues(Setting__c.Name));
	}

	@IsTest
	static void getSettingsWithoutDataRecordShouldThrowError(){
		String errorMessage;
		try{
			Settings.get(false, Setting__c.Name);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}

		Assert.messageContains(errorMessage, Label.DefaultSettingNotCreated);
	}

	@IsTest
	static void getSettingsForStringWithoutDataRecordShouldThrowError(){
		String errorMessage;
		try{
			Settings.get(false, 'Name');
		}catch(Exception e){
			errorMessage = e.getMessage();
		}

		Assert.messageContains(errorMessage, Label.DefaultSettingNotCreated);
	}

	@IsTest
	static void getSettingsWithoutDataRecordButWithBypassShouldNotThrowError(){
		String errorMessage;
		try{
			Settings.get(true, Setting__c.Name);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}

		Assert.isNull(errorMessage);
	}
}