@IsTest
private class PublicHolidaysSelectorTest{

	@IsTest
	static void selectAllShouldReturnAllCountries(){
		Test.startTest();
		Map<String, Map<String, Set<String>>> allHolidays = PublicHolidaysSelector.newInstance().selectAll();
		Test.stopTest();

		Assert.isNotNull(allHolidays);
		Assert.isTrue(allHolidays.containsKey('FR'));
		Assert.isTrue(allHolidays.containsKey('BE'));
		Assert.isTrue(allHolidays.containsKey('ES'));
	}

	@IsTest
	static void selectAllShouldReturnHolidaysByYear(){
		Test.startTest();
		Map<String, Map<String, Set<String>>> allHolidays = PublicHolidaysSelector.newInstance().selectAll();
		Test.stopTest();

		Map<String, Set<String>> frHolidays = allHolidays.get('FR');
		Assert.isNotNull(frHolidays);
		Assert.isTrue(frHolidays.containsKey('2024'));
		Assert.isTrue(frHolidays.containsKey('2025'));
		Set<String> holidays2024 = frHolidays.get('2024');
		Assert.isNotNull(holidays2024);
		Assert.isTrue(holidays2024.contains('2024-07-14'));
		Assert.isTrue(holidays2024.contains('2024-01-01'));
	}

	@IsTest
	static void selectAllShouldCacheResults(){
		Test.startTest();
		IPublicHolidaysSelector selector1 = PublicHolidaysSelector.newInstance();
		IPublicHolidaysSelector selector2 = PublicHolidaysSelector.newInstance();
		Map<String, Map<String, Set<String>>> holidays1 = selector1.selectAll();
		Map<String, Map<String, Set<String>>> holidays2 = selector2.selectAll();
		Test.stopTest();

		Assert.isNotNull(holidays1);
		Assert.isNotNull(holidays2);
		Assert.equals(holidays1, holidays2);
	}

	@IsTest
	static void selectByCountryCodeWithValidCountryCodeShouldReturnHolidays(){
		Test.startTest();
		Map<String, Set<String>> frHolidays = PublicHolidaysSelector.newInstance().selectByCountryCode('FR');
		Test.stopTest();

		Assert.isNotNull(frHolidays);
		Assert.isTrue(frHolidays.containsKey('2024'));
		Assert.isTrue(frHolidays.containsKey('2025'));
		Set<String> holidays2024 = frHolidays.get('2024');
		Assert.isNotNull(holidays2024);
		Assert.isTrue(holidays2024.contains('2024-07-14'));
		Assert.isTrue(holidays2024.contains('2024-01-01'));
	}

	@IsTest
	static void selectByCountryCodeWithLowercaseCountryCodeShouldWork(){
		Test.startTest();
		Map<String, Set<String>> frHolidays = PublicHolidaysSelector.newInstance().selectByCountryCode('fr');
		Test.stopTest();

		Assert.isNotNull(frHolidays);
		Assert.isTrue(frHolidays.containsKey('2024'));
	}

	@IsTest
	static void selectByCountryCodeWithMixedCaseCountryCodeShouldWork(){
		Test.startTest();
		Map<String, Set<String>> frHolidays = PublicHolidaysSelector.newInstance().selectByCountryCode('Fr');
		Test.stopTest();

		Assert.isNotNull(frHolidays);
		Assert.isTrue(frHolidays.containsKey('2024'));
	}

	@IsTest
	static void selectByCountryCodeWithInvalidCountryCodeShouldReturnEmptyMap(){
		Test.startTest();
		Map<String, Set<String>> holidays = PublicHolidaysSelector.newInstance().selectByCountryCode('XX');
		Test.stopTest();

		Assert.isNotNull(holidays);
		Assert.isTrue(holidays.isEmpty());
	}

	@IsTest
	static void selectByCountryCodeWithNullCountryCodeShouldReturnEmptyMap(){
		Test.startTest();
		Map<String, Set<String>> holidays = PublicHolidaysSelector.newInstance().selectByCountryCode(null);
		Test.stopTest();

		Assert.isNotNull(holidays);
		Assert.isTrue(holidays.isEmpty());
	}

	@IsTest
	static void selectByCountryCodeWithBlankCountryCodeShouldReturnEmptyMap(){
		Test.startTest();
		Map<String, Set<String>> holidays = PublicHolidaysSelector.newInstance().selectByCountryCode('');
		Test.stopTest();

		Assert.isNotNull(holidays);
		Assert.isTrue(holidays.isEmpty());
	}

	@IsTest
	static void selectByCountryCodeForBelgiumShouldReturnHolidays(){
		Test.startTest();
		Map<String, Set<String>> beHolidays = PublicHolidaysSelector.newInstance().selectByCountryCode('BE');
		Test.stopTest();

		Assert.isNotNull(beHolidays);
		Assert.isTrue(beHolidays.containsKey('2024'));
		Set<String> holidays2024 = beHolidays.get('2024');
		Assert.isNotNull(holidays2024);
		Assert.isTrue(holidays2024.contains('2024-07-21'));
	}

	@IsTest
	static void selectByCountryCodeForSpainShouldReturnHolidays(){
		Test.startTest();
		Map<String, Set<String>> esHolidays = PublicHolidaysSelector.newInstance().selectByCountryCode('ES');
		Test.stopTest();

		Assert.isNotNull(esHolidays);
		Assert.isTrue(esHolidays.containsKey('2024'));
		Set<String> holidays2024 = esHolidays.get('2024');
		Assert.isNotNull(holidays2024);
		Assert.isTrue(holidays2024.contains('2024-01-06'));
	}
}
