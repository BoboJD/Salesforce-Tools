global inherited sharing class PublicHolidaysService{

	global static Boolean isPublicHoliday(Date dateValue, String countryCode){
		return service().isPublicHoliday(dateValue, countryCode);
	}

	global static Boolean isPublicHoliday(Date dateValue){
		return service().isPublicHoliday(dateValue);
	}

	private static IPublicHolidaysService service(){
		return (IPublicHolidaysService)Application.Service.newInstance(IPublicHolidaysService.class);
	}
}
