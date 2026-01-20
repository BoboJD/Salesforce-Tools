@IsTest
private class PublicHolidaysServiceTest{

	@IsTest
	static void isPublicHolidayWithDateAndCountryCodeShouldReturnTrue(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IPublicHolidaysSelector publicHolidaysSelectorMock = new Mocks.PublicHolidaysSelector(mocks);

		Date bastilleDay = Date.newInstance(2024, 7, 14);
		Map<String, Set<String>> holidaysByYear = new Map<String, Set<String>>{
			'2024' => new Set<String>{'2024-07-14'}
		};

		mocks.startStubbing();
		mocks.when(publicHolidaysSelectorMock.selectByCountryCode('FR')).thenReturn(holidaysByYear);
		mocks.stopStubbing();

		PublicHolidaysSelector.mockInstance = publicHolidaysSelectorMock;

		Test.startTest();
		Boolean isHoliday = PublicHolidaysService.isPublicHoliday(bastilleDay, 'FR');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithDateAndCountryCodeShouldReturnFalse(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IPublicHolidaysSelector publicHolidaysSelectorMock = new Mocks.PublicHolidaysSelector(mocks);

		Date nonHoliday = Date.newInstance(2024, 7, 15);
		Map<String, Set<String>> holidaysByYear = new Map<String, Set<String>>{
			'2024' => new Set<String>{'2024-07-14'}
		};

		mocks.startStubbing();
		mocks.when(publicHolidaysSelectorMock.selectByCountryCode('FR')).thenReturn(holidaysByYear);
		mocks.stopStubbing();

		PublicHolidaysSelector.mockInstance = publicHolidaysSelectorMock;

		Test.startTest();
		Boolean isHoliday = PublicHolidaysService.isPublicHoliday(nonHoliday, 'FR');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithNullDateShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = PublicHolidaysService.isPublicHoliday(null, 'FR');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithNullCountryCodeShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = PublicHolidaysService.isPublicHoliday(Date.today(), null);
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithDateOnlyShouldCallOrganizationsService(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);
		IPublicHolidaysSelector publicHolidaysSelectorMock = new Mocks.PublicHolidaysSelector(mocks);

		Date bastilleDay = Date.newInstance(2024, 7, 14);
		Map<String, Set<String>> holidaysByYear = new Map<String, Set<String>>{
			'2024' => new Set<String>{'2024-07-14'}
		};

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('FR');
		mocks.when(publicHolidaysSelectorMock.selectByCountryCode('FR')).thenReturn(holidaysByYear);
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);
		PublicHolidaysSelector.mockInstance = publicHolidaysSelectorMock;

		Test.startTest();
		Boolean isHoliday = PublicHolidaysService.isPublicHoliday(bastilleDay);
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.isTrue(isHoliday);
	}
}
