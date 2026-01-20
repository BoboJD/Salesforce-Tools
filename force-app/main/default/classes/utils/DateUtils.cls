@SuppressWarnings('PMD.ExcessiveParameterList,PMD.CognitiveComplexity')
global inherited sharing class DateUtils{
	global static Datetime nowDate;

	global static Datetime now(){
		if(nowDate == null)
			nowDate = System.now();
		return nowDate;
	}

	global static Decimal getNumberOfMonthsBetweenTwoDates(Datetime startDate, Datetime endDate){
		return getNumberOfMonthsBetweenTwoDates(startDate?.date(), endDate?.date());
	}

	global static Decimal getNumberOfMonthsBetweenTwoDates(Date startDate, Date endDate){
		if(startDate == null || endDate == null) return null;
		Decimal monthDiff = startDate.monthsBetween(endDate);
		if(endDate.day() > startDate.day())
			monthDiff++;
		return monthDiff;
	}

	global static List<String> getYearsBetweenTwoDates(Date startDate, Date endDate){
		if(startDate == null || endDate == null) return null;
		List<String> years = new List<String>();
		Integer year = startDate.year();
		do{
			years.add(String.valueOf(year));
			year++;
		}while(year <= endDate.year());
		return years;
	}

	global static Datetime convertEnedisDatetimeToSalesforceFormat(String datetimeStr){
		if(String.isBlank(datetimeStr)) return null;
		Date d = Date.valueOf(datetimeStr.split('T')[0]);
		return Datetime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
	}

	global static String formatDate(Date inputDate){
		return formatDate(inputDate, 'dd/MM/yyyy');
	}

	global static String formatDate(Date inputDate, String format){
		if(inputDate == null || format == null) return null;
		Datetime inputDatetime = Datetime.newInstance(inputDate.year(), inputDate.month(), inputDate.day(), 0, 0, 0);
		return inputDatetime.format(format);
	}

	global static Integer businessDaysBetween(Date startDate, Date endDate){
		return businessDaysBetween(startDate, endDate, OrganizationsService.retrieveCountryCode());
	}

	global static Integer businessDaysBetween(Date startDate, Date endDate, String countryCode){
		if(startDate == null || endDate == null) return null;
		Integer numberOfBusinessDays = 0;
		Date dateToCheck = startDate;
		while(dateToCheck < endDate){
			if(!isWeekendDay(dateToCheck) && !isPublicHoliday(dateToCheck, countryCode))
				numberOfBusinessDays++;
			dateToCheck = dateToCheck.addDays(1);
		}
		return numberOfBusinessDays;
	}

	global static Date addBusinessDays(Date startDate, Integer businessDaysToAdd){
		return addBusinessDays(startDate, businessDaysToAdd, OrganizationsService.retrieveCountryCode());
	}

	global static Date addBusinessDays(Date startDate, Integer businessDaysToAdd, String countryCode){
		if(startDate == null || businessDaysToAdd == null) return startDate;
		Date finalDate = startDate;
		Integer direction = businessDaysToAdd < 0 ? -1 : 1;
		while(businessDaysToAdd != 0){
			finalDate = finalDate.addDays(direction);
			if(!isWeekendDay(finalDate) && !isPublicHoliday(finalDate, countryCode))
				businessDaysToAdd -= direction;
		}
		return finalDate;
	}

	global static Boolean isWeekendDay(Date inputDate){
		if(inputDate == null) return false;
		Datetime dateT = Datetime.newInstance(inputDate, Time.newInstance(0, 0, 0, 0));
		return (dateT.format('E') == 'Sun' || dateT.format('E') == 'Sat');
	}

	global static Integer dayOfWeek(Datetime inputDate){
		return dayOfWeek(inputDate?.date());
	}

	global static Integer dayOfWeek(Date inputDate){
		if(inputDate == null) return null;
		return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(inputDate), 7);
	}

	global static Boolean isFriday(Date inputDate){
		return dayOfWeek(inputDate) == 5;
	}

	global static Boolean isSunday(Datetime inputDate){
		return dayOfWeek(inputDate) == 0;
	}

	global static Boolean periodOverlap(Date startDateToCompare, Date endDateToCompare, Date referenceStartDate, Date referenceEndDate){
		return (referenceStartDate <= startDateToCompare && startDateToCompare < referenceEndDate)
			|| (referenceStartDate < endDateToCompare && endDateToCompare <= referenceEndDate)
			|| (startDateToCompare < referenceStartDate && referenceEndDate < endDateToCompare);
	}

	global static Date changeYear(Date originalDate, Integer newYear){
		if(originalDate == null || newYear == null)
			throw new IllegalArgumentException('Date and year must not be null.');
		Integer month = originalDate.month();
		Integer day = originalDate.day();
		if(month == 2 && day == 29 && !Date.isLeapYear(newYear))
			day = 28;
		return Date.newInstance(newYear, month, day);
	}

	global static Boolean isEndOfMonth(Date inputDate){
		if(inputDate == null) return false;
		Integer year = inputDate.year();
		Integer month = inputDate.month();
		Integer day = inputDate.day();
		Integer lastDay = Date.daysInMonth(year, month);
		return day == lastDay;
	}

	global static Boolean isPublicHoliday(Date inputDate){
		return isPublicHoliday(inputDate, OrganizationsService.retrieveCountryCode());
	}

	global static Boolean isPublicHoliday(Date inputDate, String countryCode){
		if(inputDate == null || String.isBlank(countryCode)) return false;
		Map<String, Map<String, Set<String>>> publicHolidaysCache = PublicHolidaysSelector.newInstance().selectAll();
		String year = String.valueOf(inputDate.year());
		String dateStr = formatDate(inputDate, 'yyyy-MM-dd');
		return publicHolidaysCache?.containsKey(countryCode.toUpperCase())
			&& publicHolidaysCache.get(countryCode.toUpperCase()).containsKey(year)
			&& publicHolidaysCache.get(countryCode.toUpperCase()).get(year).contains(dateStr);
	}
}