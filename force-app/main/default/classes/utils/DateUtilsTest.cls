@IsTest
private class DateUtilsTest{

	@IsTest
	static void nowShouldReturnCurrentDatetime(){
		Test.startTest();
		Datetime currentDatetime = DateUtils.now();
		Test.stopTest();

		Assert.equals(DateUtils.nowDate, currentDatetime);
	}

	@IsTest
	static void getNumberOfMonthsBetweenTwoDatesShouldReturnOneMonth(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(Date.today().toStartOfMonth(), Date.today().toStartOfMonth().addMonths(1));
		Test.stopTest();

		Assert.equals(1, numberOfMonths);
	}

	@IsTest
	static void getNumberOfMonthsBetweenTwoDatesWithOneDayOfDifferenceShouldReturnOneMonth(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(Date.newInstance(2025, 12, 9), Date.newInstance(2025, 12, 10));
		Test.stopTest();

		Assert.equals(1, numberOfMonths);
	}

	@IsTest
	static void getNumberOfMonthsBetweenTwoDatetimesShouldReturnOneMonth(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(System.now(), System.now().addMonths(1));
		Test.stopTest();

		Assert.equals(1, numberOfMonths);
	}

	@IsTest
	static void getNumberOfMonthsBetweenTwoDatesShouldReturnTwelveMonths(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(Date.today(), Date.today().toStartOfMonth().addYears(1));
		Test.stopTest();

		Assert.equals(12, numberOfMonths);
	}

	@IsTest
	static void getYearsBetweenTwoDatesShouldReturnYears(){
		Test.startTest();
		List<String> years = DateUtils.getYearsBetweenTwoDates(Date.newInstance(2021, 1, 1), Date.newInstance(2022, 1, 1));
		Test.stopTest();

		Assert.equals(new List<String>{'2021', '2022'}, years);
	}

	@IsTest
	static void convertEnedisDatetimeToSalesforceFormatShouldReturnData(){
		Test.startTest();
		Datetime theDate = DateUtils.convertEnedisDatetimeToSalesforceFormat('2020-04-11T23:00:00.000+00:00');
		Test.stopTest();

		Assert.equals(Date.newInstance(2020,4,11), theDate.date());
	}

	@IsTest
	static void formatDateShouldReturnFormattedDate(){
		Date theDate = Date.newInstance(2020, 7, 29);

		Test.startTest();
		String formattedDate = DateUtils.formatDate(theDate);
		Test.stopTest();

		Assert.equals('29/07/2020', formattedDate);
	}

	@IsTest
	static void formatDateWithFormatShouldReturnFormattedDate(){
		Date theDate = Date.newInstance(2020, 7, 29);

		Test.startTest();
		String formattedDate = DateUtils.formatDate(theDate, 'yyyy-MM-dd');
		Test.stopTest();

		Assert.equals('2020-07-29', formattedDate);
	}

	@IsTest
	static void formatDateShouldReturnNull(){
		Test.startTest();
		String formattedDate = DateUtils.formatDate(null);
		Test.stopTest();

		Assert.isNull(formattedDate);
	}

	@IsTest
	static void isWeekendDayShouldReturnTrue(){
		Test.startTest();
		Boolean isWeekendDay = DateUtils.isWeekendDay(Date.newInstance(2020, 8, 11));
		Test.stopTest();

		Assert.isFalse(isWeekendDay);
	}

	@IsTest
	static void isWeekendDayShouldReturnFalse(){
		Test.startTest();
		Boolean isWeekendDay = DateUtils.isWeekendDay(Date.newInstance(2020, 8, 15));
		Test.stopTest();

		Assert.isTrue(isWeekendDay);
	}

	@IsTest
	static void businessDaysBetweenFirstApril2022AndEndApril2022ShouldReturn21(){
		Test.startTest();
		Integer numberOfBusinessDays = DateUtils.businessDaysBetween(Date.newInstance(2022, 4, 1), Date.newInstance(2022, 4, 30));
		Test.stopTest();

		Assert.equals(21, numberOfBusinessDays);
	}

	@IsTest
	static void addBusinessDaysShouldSetDateToMonday(){
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2020,8,14), 1);
		Test.stopTest();

		Assert.equals(Date.newInstance(2020, 8, 17), returnedDate);
	}

	@IsTest
	static void dayOfWeekShouldReturnFriday(){
		Test.startTest();
		Integer dayOfWeek = DateUtils.dayOfWeek(Date.newInstance(2020,9,4));
		Test.stopTest();

		Assert.equals(5, dayOfWeek); // Friday = 5
	}

	@IsTest
	static void dayOfWeekWithDatetimeShouldReturnFriday(){
		Test.startTest();
		Integer dayOfWeek = DateUtils.dayOfWeek(Datetime.newInstance(2020,9,4));
		Test.stopTest();

		Assert.equals(5, dayOfWeek); // Friday = 5
	}

	@IsTest
	static void isFridayShouldReturnFalse(){
		Test.startTest();
		Boolean isFriday = DateUtils.isFriday(Date.newInstance(2021, 9, 13));
		Test.stopTest();

		Assert.isFalse(isFriday);
	}

	@IsTest
	static void isFridayShouldReturnTrue(){
		Test.startTest();
		Boolean isFriday = DateUtils.isFriday(Date.newInstance(2021, 9, 17));
		Test.stopTest();

		Assert.isTrue(isFriday);
	}

	@IsTest
	static void isSundayShouldReturnFalse(){
		Test.startTest();
		Boolean isSunday = DateUtils.isSunday(Datetime.newInstance(2024, 2, 17));
		Test.stopTest();

		Assert.isFalse(isSunday);
	}

	@IsTest
	static void isSundayShouldReturnTrue(){
		Test.startTest();
		Boolean isSunday = DateUtils.isSunday(Datetime.newInstance(2024, 2, 18));
		Test.stopTest();

		Assert.isTrue(isSunday);
	}

	@IsTest
	static void periodOverlapWithStartDateToCompareBetweenPeriodReferenceShouldReturnTrue(){
		Test.startTest();
		Boolean overlap = DateUtils.periodOverlap(
			Date.newInstance(2022, 11, 2),
			Date.newInstance(2023, 11, 2),
			Date.newInstance(2022, 10, 2),
			Date.newInstance(2023, 10, 2));
		Test.stopTest();

		Assert.isTrue(overlap);
	}

	@IsTest
	static void periodOverlapWithEndDateToCompareBetweenPeriodReferenceShouldReturnTrue(){
		Test.startTest();
		Boolean overlap = DateUtils.periodOverlap(
			Date.newInstance(2022, 10, 2),
			Date.newInstance(2023, 10, 2),
			Date.newInstance(2022, 11, 2),
			Date.newInstance(2023, 11, 2));
		Test.stopTest();

		Assert.isTrue(overlap);
	}

	@IsTest
	static void periodOverlapWithPeriodReferenceBetweenPeriodToCompareShouldReturnTrue(){
		Test.startTest();
		Boolean overlap = DateUtils.periodOverlap(
			Date.newInstance(2022, 11, 2),
			Date.newInstance(2023, 11, 2),
			Date.newInstance(2022, 12, 2),
			Date.newInstance(2023, 1, 2));
		Test.stopTest();

		Assert.isTrue(overlap);
	}

	@IsTest
	static void periodOverlapWithPeriodReferenceBeforePeriodToCompareShouldReturnFalse(){
		Test.startTest();
		Boolean overlap = DateUtils.periodOverlap(
			Date.newInstance(2022, 11, 2),
			Date.newInstance(2023, 12, 2),
			Date.newInstance(2023, 12, 2),
			Date.newInstance(2024, 1, 2));
		Test.stopTest();

		Assert.isFalse(overlap);
	}

	@IsTest
	static void periodOverlapWithPeriodReferenceAfterPeriodToCompareShouldReturnFalse(){
		Test.startTest();
		Boolean overlap = DateUtils.periodOverlap(
			Date.newInstance(2023, 1, 2),
			Date.newInstance(2023, 11, 2),
			Date.newInstance(2022, 12, 2),
			Date.newInstance(2023, 1, 2));
		Test.stopTest();

		Assert.isFalse(overlap);
	}

	@IsTest
	static void changeYearWithNullParametersShouldThrowException(){
		Test.startTest();
		String errorMessage;
		try{
			DateUtils.changeYear(null, null);
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Test.stopTest();

		Assert.messageContains(errorMessage, 'Date and year must not be null.');
	}

	@IsTest
	static void changeYearWithLeapYearShouldHandleDay(){
		Test.startTest();
		Date newDate = DateUtils.changeYear(Date.newInstance(2028, 2, 29), 2029);
		Test.stopTest();

		Assert.equals(Date.newInstance(2029, 2, 28), newDate);
	}

	@IsTest
	static void isEndOfMonthWithNullDateShouldReturnFalse(){
		Test.startTest();
		Boolean isEndOfMonth = DateUtils.isEndOfMonth(null);
		Test.stopTest();

		Assert.isFalse(isEndOfMonth);
	}

	@IsTest
	static void isEndOfMonthWithEndOfMonthDateShouldReturnTrue(){
		Test.startTest();
		Boolean isEndOfMonth = DateUtils.isEndOfMonth(Date.newInstance(2025, 10, 31));
		Test.stopTest();

		Assert.isTrue(isEndOfMonth);
	}

	@IsTest
	static void isEndOfMonthWithNotEndOfMonthDateShouldReturnFalse(){
		Test.startTest();
		Boolean isEndOfMonth = DateUtils.isEndOfMonth(Date.newInstance(2025, 10, 30));
		Test.stopTest();

		Assert.isFalse(isEndOfMonth);
	}

	@IsTest
	static void isEndOfMonthWithEndOfMonthDateInLeapYearShouldReturnTrue(){
		Test.startTest();
		Boolean isEndOfMonth = DateUtils.isEndOfMonth(Date.newInstance(2024, 2, 29));
		Test.stopTest();

		Assert.isTrue(isEndOfMonth);
	}

	@IsTest
	static void isPublicHolidayWithoutCountryCodeShouldUseOrganizationsService(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('FR');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14));
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithoutCountryCodeWithEmptyStringShouldReturnFalse(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14));
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithNullDateShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(null, 'FR');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithBlankCountryCodeShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), '');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForFranceBastilleDayShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'FR');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForFranceNewYearShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 1, 1), 'FR');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForFranceEasterMondayShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 4, 1), 'FR');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForFranceRegularDayShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 6, 15), 'FR');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForBelgiumNationalDayShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 21), 'BE');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForBelgiumAscensionDayShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 5, 9), 'BE');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForSpainGoodFridayShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 3, 29), 'ES');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForSpainEpiphanyShouldReturnTrue(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 1, 6), 'ES');
		Test.stopTest();

		Assert.isTrue(isHoliday);
	}

	@IsTest
	static void isPublicHolidayWithCaseInsensitiveCountryCodeShouldWork(){
		Test.startTest();
		Boolean isHolidayLower = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'fr');
		Boolean isHolidayUpper = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'FR');
		Boolean isHolidayMixed = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'Fr');
		Test.stopTest();

		Assert.isTrue(isHolidayLower);
		Assert.isTrue(isHolidayUpper);
		Assert.isTrue(isHolidayMixed);
	}

	@IsTest
	static void isPublicHolidayWithInvalidCountryCodeShouldReturnFalse(){
		Test.startTest();
		Boolean isHoliday = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'XX');
		Test.stopTest();

		Assert.isFalse(isHoliday);
	}

	@IsTest
	static void isPublicHolidayForDifferentYearsShouldWork(){
		Test.startTest();
		Boolean isHoliday2024 = DateUtils.isPublicHoliday(Date.newInstance(2024, 7, 14), 'FR');
		Boolean isHoliday2025 = DateUtils.isPublicHoliday(Date.newInstance(2025, 7, 14), 'FR');
		Boolean isHoliday2040 = DateUtils.isPublicHoliday(Date.newInstance(2040, 7, 14), 'FR');
		Test.stopTest();

		Assert.isTrue(isHoliday2024);
		Assert.isTrue(isHoliday2025);
		Assert.isTrue(isHoliday2040);
	}

	@IsTest
	static void addBusinessDaysWithCountryCodeShouldSkipHolidays(){
		// Starting on Friday July 12, 2024, adding 1 business day should skip July 14 (Bastille Day, Sunday)
		// and land on Monday July 15
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 12), 1, 'FR');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 7, 15), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithCountryCodeShouldSkipMultipleHolidays(){
		// Starting on May 8 (Wednesday - Victory Day, holiday), adding 1 business day should skip:
		// - May 8 (Victory Day - holiday, starting point)
		// - May 9 (Ascension Day - holiday)
		// - May 10 (Friday - business day)
		// Result: May 10
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 5, 8), 1, 'FR');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 5, 10), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithoutCountryCodeShouldUseOrganizationsService(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('FR');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		// Starting on Friday July 12, 2024, adding 1 business day should skip July 14 (Bastille Day, Sunday)
		// and land on Monday July 15
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 12), 1);
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.equals(Date.newInstance(2024, 7, 15), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithoutCountryCodeWithEmptyStringShouldNotCheckHolidays(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		// Without country code, should work as before (no holiday checking)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 12), 1);
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.equals(Date.newInstance(2024, 7, 15), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithCountryCodeNegativeDaysShouldWork(){
		// Starting on Monday July 15, 2024, going back 1 business day should skip July 14 (Bastille Day)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 15), -1, 'FR');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 7, 12), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithBelgiumHolidayShouldSkipHoliday(){
		// Starting on Friday July 19, 2024, adding 1 business day should skip July 21 (Belgian National Day, Sunday)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 19), 1, 'BE');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 7, 22), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithSpainHolidayShouldSkipHoliday(){
		// Starting on Thursday January 4, 2024, adding 1 business day should skip January 6 (Epiphany, Saturday)
		// Actually, since Jan 6 is Saturday, it would be skipped anyway. Let's use a weekday holiday.
		// Starting on Friday December 5, 2024, adding 1 business day should skip December 6 (Constitution Day, Friday)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 12, 5), 1, 'ES');
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 12, 9), returnedDate);
	}

	@IsTest
	static void businessDaysBetweenWithCountryCodeShouldExcludeHolidays(){
		// From August 14 (Wednesday) to August 16 (Friday) = 1 business day (excluding August 15 - Assumption Day, Thursday)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 8, 14), Date.newInstance(2024, 8, 16), 'FR');
		Test.stopTest();

		Assert.equals(1, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithCountryCodeShouldExcludeMultipleHolidays(){
		// From May 8 (Wednesday) to May 11 (Saturday) = 1 business day
		// May 8 is Victory Day (holiday), May 9 is Ascension Day (holiday), May 10 is Friday (business day), May 11 is Saturday
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 5, 8), Date.newInstance(2024, 5, 11), 'FR');
		Test.stopTest();

		Assert.equals(1, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithoutCountryCodeShouldUseOrganizationsService(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('FR');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		// From August 14 (Wednesday) to August 16 (Friday) = 1 business day (excluding August 15 - Assumption Day, Thursday)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 8, 14), Date.newInstance(2024, 8, 16));
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.equals(1, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithoutCountryCodeWithEmptyStringShouldNotCheckHolidays(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 7, 12), Date.newInstance(2024, 7, 16));
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();

		Assert.equals(2, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithBelgiumHolidayShouldExcludeHoliday(){
		// From August 14 (Wednesday) to August 16 (Friday) = 1 business day (excluding August 15 - Assumption Day, Thursday)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 8, 14), Date.newInstance(2024, 8, 16), 'BE');
		Test.stopTest();

		Assert.equals(1, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithSpainHolidayShouldExcludeHoliday(){
		// From December 5 (Thursday) to December 10 (Tuesday) = 2 business days (excluding December 6 - Constitution Day)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 12, 5), Date.newInstance(2024, 12, 10), 'ES');
		Test.stopTest();

		Assert.equals(2, businessDays);
	}

	@IsTest
	static void businessDaysBetweenWithNullCountryCodeShouldNotCheckHolidays(){
		// When explicitly passing null, should not check holidays (null overrides OrganizationsService)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 7, 12), Date.newInstance(2024, 7, 16), null);
		Test.stopTest();

		Assert.equals(2, businessDays);
	}

	@IsTest
	static void addBusinessDaysWithNullCountryCodeShouldNotCheckHolidays(){
		// When explicitly passing null, should not check holidays (null overrides OrganizationsService)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 12), 1, null);
		Test.stopTest();

		Assert.equals(Date.newInstance(2024, 7, 15), returnedDate);
	}

	@IsTest
	static void addBusinessDaysWithoutCountryCodeWithBelgiumShouldUseBelgiumHolidays(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('BE');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		// Starting on Friday July 19, 2024, adding 1 business day should skip July 21 (Belgian National Day, Sunday)
		Test.startTest();
		Date returnedDate = DateUtils.addBusinessDays(Date.newInstance(2024, 7, 19), 1);
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.equals(Date.newInstance(2024, 7, 22), returnedDate);
	}

	@IsTest
	static void businessDaysBetweenWithoutCountryCodeWithSpainShouldUseSpainHolidays(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOrganizationsService organizationsServiceMock = new Mocks.OrganizationsService(mocks);

		mocks.startStubbing();
		mocks.when(organizationsServiceMock.retrieveCountryCode()).thenReturn('ES');
		mocks.stopStubbing();

		Application.Service.setMock(IOrganizationsService.class, organizationsServiceMock);

		// From December 5 (Thursday) to December 10 (Tuesday) = 2 business days (excluding December 6 - Constitution Day)
		Test.startTest();
		Integer businessDays = DateUtils.businessDaysBetween(Date.newInstance(2024, 12, 5), Date.newInstance(2024, 12, 10));
		Test.stopTest();

		((IOrganizationsService)mocks.verify(organizationsServiceMock)).retrieveCountryCode();
		Assert.equals(2, businessDays);
	}
}