@SuppressWarnings('PMD.ApexUnitTestShouldNotUseSeeAllDataTrue')
@IsTest
private class ReportFileDownloaderControllerTest{

	@IsTest
	static void getUtilityDataShouldReturn1MappedData(){
		Test.startTest();
		Map<String, Object> utilityData = ReportFileDownloaderController.getUtilityData();
		Test.stopTest();

		Assert.equals(2, utilityData?.size());
		Assert.isTrue(utilityData.containsKey('fileTypes'));
		Assert.isTrue(utilityData.containsKey('label'));
	}

	@IsTest(SeeAllData=true)
	static void downloadReportFilesWithoutTypeShouldReturnSuccess(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();
			ContentVersionBuilder.newFile()
				.withRecord(account)
				.build();
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT' LIMIT 1];

			ReportFileDownloaderController.Form form = new ReportFileDownloaderController.Form();
			form.reportId = report.Id;

			Test.startTest();
			Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(JSON.serialize(form));
			Test.stopTest();

			Assert.success(result);
			Set<Id> fileIds = (Set<Id>)result.get('fileIds');
			Assert.equals(1, fileIds?.size());
		}
	}

	@IsTest(SeeAllData=true)
	static void downloadReportFilesWithTypeShouldReturnSuccess(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account account = AccountBuilder.newAccount().build();
			ContentVersionBuilder.newFile()
				.withFileType('Test')
				.withRecord(account)
				.build();
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT' LIMIT 1];

			ReportFileDownloaderController.Form form = new ReportFileDownloaderController.Form();
			form.reportId = report.Id;
			form.fileType = 'Test';

			Test.startTest();
			Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(JSON.serialize(form));
			Test.stopTest();

			Assert.success(result);
			Set<Id> fileIds = (Set<Id>)result.get('fileIds');
			Assert.equals(1, fileIds?.size());
		}
	}

	@IsTest(SeeAllData=true)
	static void downloadReportFilesWithNoRecordsShouldThrowError(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT' LIMIT 1];

			ReportFileDownloaderController.Form form = new ReportFileDownloaderController.Form();
			form.reportId = report.Id;

			Test.startTest();
			Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(JSON.serialize(form));
			Test.stopTest();

			Assert.errorWithMessage(result, Label.TheReportHasNoRecords);
		}
	}

	@IsTest(SeeAllData=true)
	static void downloadReportFilesWithWrongReportShouldThrowError(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT_WRONG_COLUMN' LIMIT 1];

			ReportFileDownloaderController.Form form = new ReportFileDownloaderController.Form();
			form.reportId = report.Id;

			Test.startTest();
			Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(JSON.serialize(form));
			Test.stopTest();

			Assert.errorWithMessage(result, Label.TheRecordIdShouldBeTheFirstColumnOfYourReport);
		}
	}

	@IsTest(SeeAllData=true)
	static void downloadReportFilesWithoutFileShouldReturnError(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			AccountBuilder.newAccount().build();
			Report report = [SELECT Id FROM Report WHERE DeveloperName = 'TEST_MY_ACCOUNT' LIMIT 1];

			ReportFileDownloaderController.Form form = new ReportFileDownloaderController.Form();
			form.reportId = report.Id;

			Test.startTest();
			Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(JSON.serialize(form));
			Test.stopTest();

			Assert.errorWithMessage(result, Label.NoFilesWereFoundInTheRecordsRelatedToYourReport);
		}
	}

	@IsTest
	static void downloadReportFilesWithNullParameterShouldReturnErrorAndCommitOneLog(){
		Test.startTest();
		Map<String, Object> result = ReportFileDownloaderController.downloadReportFiles(null);
		Test.stopTest();

		Assert.errorWithLog(result);
	}
}