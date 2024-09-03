global class SetUtils{

	global static Set<Id> transformListStringToSetId(List<String> stringList){
		Set<Id> ids = new Set<Id>();
		for(String stringId : stringList) ids.add(stringId);
		return ids;
	}

	global static Boolean hasStrings(Set<String> terms){
		if(terms == null || terms.isEmpty()) return false;
		for(String term : terms)
			if(String.isNotBlank(term)) return true;
		return false;
	}
}