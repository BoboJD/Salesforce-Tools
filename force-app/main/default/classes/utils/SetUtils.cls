global class SetUtils{

	global static Set<Id> transformListStringToSetId(List<String> stringList){
		Set<Id> ids = new Set<Id>();
		for(String stringId : stringList) ids.add(stringId);
		return ids;
	}
}