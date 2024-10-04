@IsTest
private class SettingsTest{

	@IsTest
	static void getSettingsNameShouldReturnDefault(){
		insert new Setting__c(Name = 'Default');
		Assert.equals('Default', Settings.get(Setting__c.Name));
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