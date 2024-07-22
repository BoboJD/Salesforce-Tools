public class MapUtils{

	public static Object get(Map<String, Object> parentNode, List<String> childNodes){
		if(parentNode == null || childNodes == null || childNodes.isEmpty()) return null;
		Object childNode = parentNode.get(childNodes.remove(0));
		if(childNodes.isEmpty())
			return childNode;
		return get((Map<String, Object>)childNode, childNodes);
	}
}