@SuppressWarnings('PMD.ExcessiveParameterList, PMD.CognitiveComplexity')
public inherited sharing class DateUtils{
	@TestVisible private static Datetime nowDate;

	public static Datetime now(){
		if(nowDate == null)
			nowDate = System.now();
		return nowDate;
	}

	public static Decimal getNumberOfMonthsBetweenTwoDates(Datetime startDate, Datetime endDate){
		return getNumberOfMonthsBetweenTwoDates(startDate?.date(), endDate?.date());
	}

	public static Decimal getNumberOfMonthsBetweenTwoDates(Date startDate, Date endDate){
		Decimal monthDiff = 0;
		if(startDate != null && endDate != null){
			monthDiff = startDate.monthsBetween(endDate);
			if(endDate.day() > startDate.day()) monthDiff++;
		}
		return monthDiff;
	}

	public static List<String> getYearsBetweenTwoDates(Date startDate, Date endDate){
		List<String> years = new List<String>();
		Integer year = startDate.year();
		do{
			years.add(String.valueOf(year));
			year++;
		}while(year <= endDate.year());
		return years;
	}

	public static Datetime convertEnedisDatetimeToSalesforceFormat(String datetimeStr){
		Datetime dt;
		if(String.isNotBlank(datetimeStr)){
			Date d = Date.valueOf(datetimeStr.split('T')[0]);
			dt = Datetime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
		}
		return dt;
	}

	public static String formatDate(Date theDate){
		return formatDate(theDate, 'dd/MM/yyyy');
	}

	public static String formatDate(Date theDate, String format){
		String formattedDate;
		if(theDate != null){
			Datetime theDatetime = Datetime.newInstance(theDate.year(), theDate.month(), theDate.day(), 0, 0, 0);
			formattedDate = theDatetime.format(format);
		}
		return formattedDate;
	}

	public static Integer businessDaysBetween(Date startDate, Date endDate){
		Integer numberOfBusinessDays = 0;
		Date dateToCheck = startDate;
		while(dateToCheck < endDate){
			String day = Datetime.newInstance(dateToCheck.year(), dateToCheck.month(), dateToCheck.day()).format('E');
			if(day != 'Sat' && day != 'Sun')
				numberOfBusinessDays++;
			dateToCheck = dateToCheck.addDays(1);
		}
		return numberOfBusinessDays;
	}

	public static Date addBusinessDays(Date startDate, Integer businessDaysToAdd){
		Date finalDate = startDate;
		if(finalDate != null){
			Integer direction = businessDaysToAdd < 0 ? -1 : 1;
			while(businessDaysToAdd != 0){
				finalDate = finalDate.addDays(direction);
				if(!isWeekendDay(finalDate))
					businessDaysToAdd -= direction;
			}
		}
		return finalDate;
	}

	public static Boolean isWeekendDay(Date dateParam){
		Datetime dateT = Datetime.newInstance(dateParam, Time.newInstance(0, 0, 0, 0));
		return (dateT.format('E') == 'Sun' || dateT.format('E') == 'Sat');
	}

	// Dimanche = 0, Lundi = 1, ..., Samedi = 6
	public static Integer dayOfWeek(Datetime theDate){
		return theDate != null ? dayOfWeek(theDate.date()) : null;
	}

	public static Integer dayOfWeek(Date theDate){
		return theDate != null ? Math.mod(Date.newInstance(1900, 1, 7).daysBetween(theDate),7) : null;
	}

	public static Boolean isFriday(Date theDate){
		return dayOfWeek(theDate) == 5;
	}

	public static Boolean isSunday(Datetime theDate){
		return dayOfWeek(theDate) == 0;
	}

	public static Boolean periodOverlap(Date startDateToCompare, Date endDateToCompare, Date referenceStartDate, Date referenceEndDate){
		return (referenceStartDate <= startDateToCompare && startDateToCompare < referenceEndDate)
			|| (referenceStartDate < endDateToCompare && endDateToCompare <= referenceEndDate)
			|| (startDateToCompare < referenceStartDate && referenceEndDate < endDateToCompare);
	}
}