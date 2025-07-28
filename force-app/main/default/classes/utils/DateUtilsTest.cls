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
	static void getNumberOfMonthsBetweenTwoDatetimesShouldReturnOneMonth(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(System.now(), System.now().addMonths(1));
		Test.stopTest();

		Assert.equals(1, numberOfMonths);
	}

	@IsTest
	static void getNumberOfMonthsBetweenTwoDatesShouldReturnOneYear(){
		Test.startTest();
		Decimal numberOfMonths = DateUtils.getNumberOfMonthsBetweenTwoDates(Date.today().toStartOfMonth(), Date.today().toStartOfMonth().addYears(1));
		Test.stopTest();

		Assert.equals(12, numberOfMonths);
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
}