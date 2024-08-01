public inherited sharing class ApexPagesUtils{

	public static Set<Id> extractSetIdsParameterFromUrl(String parameter){
		String setIdsString = ApexPages.currentPage().getParameters().get(parameter);
		return String.isNotBlank(setIdsString) ? SetUtils.transformListStringToSetId(setIdsString.split(',')) : new Set<Id>();
	}

	public static Date extractDateParameterFromUrl(String parameter){
		String dateString = ApexPages.currentPage().getParameters().get(parameter);
		return String.isNotBlank(dateString) ? Date.valueOf(dateString) : null;
	}

	public static String extractStringParameterFromUrl(String parameter){
		return ApexPages.currentPage().getParameters().get(parameter);
	}

	public static Boolean extractBooleanParameterFromUrl(String parameter){
		String booleanStr = ApexPages.currentPage().getParameters().get(parameter);
		return String.isNotBlank(booleanStr) && booleanStr.equalsIgnoreCase('true');
	}
}