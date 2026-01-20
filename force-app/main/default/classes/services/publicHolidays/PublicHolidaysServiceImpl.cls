global inherited sharing class PublicHolidaysServiceImpl implements IPublicHolidaysService{

	global Boolean isPublicHoliday(Date dateValue, String countryCode){
		if(dateValue == null || String.isBlank(countryCode)) return false;
		String year = String.valueOf(dateValue.year());
		String dateString = String.valueOf(dateValue);
		Map<String, Set<String>> holidaysByYear = PublicHolidaysSelector.newInstance().selectByCountryCode(countryCode);
		Set<String> holidays = holidaysByYear.get(year);
		return holidays != null && holidays.contains(dateString);
	}

	global Boolean isPublicHoliday(Date dateValue){
		return isPublicHoliday(dateValue, OrganizationsService.retrieveCountryCode());
	}
}
