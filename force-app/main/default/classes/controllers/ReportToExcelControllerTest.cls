@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
@IsTest
private class ReportToExcelControllerTest{

	@IsTest(SeeAllData=true)
	static void initControllerShouldHavePropertiesInitialized(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT_WITH_FILTER' LIMIT 1];
			ApexPages.currentPage().getParameters().put('reportId', report.Id);
			ApexPages.currentPage().getParameters().put('fv0', account.Id);
			ApexPages.currentPage().getParameters().put('fileName', 'Test');

			Test.startTest();
			ReportToExcelController controller = new ReportToExcelController();
			Test.stopTest();

			Assert.equals('application/vnd.ms-excel#Test.xls', controller.excelTitle);
			Assert.equals(Constants.XML_HEADER, controller.xmlheader);
			Assert.equals(2, controller.rows.size());
		}
	}
}