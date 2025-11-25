global class ListUtils{

	global static Object last(List<Object> objects){
		if(objects == null || objects.isEmpty()) return null;
		return objects[objects.size() - 1];
	}
}