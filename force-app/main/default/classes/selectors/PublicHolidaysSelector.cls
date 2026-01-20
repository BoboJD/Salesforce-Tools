global inherited sharing class PublicHolidaysSelector implements IPublicHolidaysSelector{
	private static Map<String, Map<String, Set<String>>> publicHolidaysCache;
	@TestVisible
	private static IPublicHolidaysSelector mockInstance;

	global static IPublicHolidaysSelector newInstance(){
		if(Test.isRunningTest() && mockInstance != null) return mockInstance;
		return new PublicHolidaysSelector();
	}

	@SuppressWarnings('PMD.ApexCRUDViolation')
	global Map<String, Map<String, Set<String>>> selectAll(){
		if(publicHolidaysCache != null) return publicHolidaysCache;
		publicHolidaysCache = new Map<String, Map<String, Set<String>>>();
		StaticResource resource = [SELECT Body FROM StaticResource WHERE Name = 'PublicHolidays' LIMIT 1];
		String jsonContent = resource.Body.toString();
		Map<String, Object> holidaysByCountry = (Map<String, Object>)JSON.deserializeUntyped(jsonContent);
		for(String countryCode : holidaysByCountry.keySet()){
			Map<String, Object> holidaysByYear = (Map<String, Object>)holidaysByCountry.get(countryCode);
			Map<String, Set<String>> yearMap = new Map<String, Set<String>>();
			for(String year : holidaysByYear.keySet()){
				List<Object> holidays = (List<Object>)holidaysByYear.get(year);
				Set<String> holidaySet = new Set<String>();
				for(Object holiday : holidays){
					holidaySet.add((String)holiday);
				}
				yearMap.put(year, holidaySet);
			}
			publicHolidaysCache.put(countryCode, yearMap);
		}
		return publicHolidaysCache;
	}

	global Map<String, Set<String>> selectByCountryCode(String countryCode){
		if(String.isBlank(countryCode)) return new Map<String, Set<String>>();
		Map<String, Map<String, Set<String>>> allHolidays = selectAll();
		return allHolidays.get(countryCode.toUpperCase()) != null
			? allHolidays.get(countryCode.toUpperCase())
			: new Map<String, Set<String>>();
	}
}
