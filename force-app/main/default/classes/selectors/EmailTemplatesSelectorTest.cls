@IsTest
private class EmailTemplatesSelectorTest{

	@IsTest
	static void selectByDeveloperNameShouldReturnOneRecord(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Test.startTest();
			EmailTemplate emailTemplate = EmailTemplatesSelector.newInstance().selectByDeveloperName('CommerceReorderPortalInvitation');
			Test.stopTest();

			Assert.isNotNull(emailTemplate);
		}
	}
}