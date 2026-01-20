global interface IPublicHolidaysSelector{
	Map<String, Map<String, Set<String>>> selectAll();
	Map<String, Set<String>> selectByCountryCode(String countryCode);
}
