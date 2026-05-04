global class ListUtils{

	global static Object last(List<Object> objects){
		if(objects == null || objects.isEmpty()) return null;
		return objects[objects.size() - 1];
	}

	global static List<Id> toIdList(List<String> strings){
		List<Id> ids = new List<Id>();
		if(strings == null) return ids;
		for(String s : strings) if(String.isNotBlank(s)) ids.add((Id)s);
		return ids;
	}
}