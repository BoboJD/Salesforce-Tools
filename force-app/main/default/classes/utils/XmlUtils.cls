public inherited sharing class XmlUtils{

	private static final Map<String, String> ESCAPED_CHARACTERS = new Map<String, String>{
		'&' => 'amp',
		'"' => 'quot',
		'\'' => 'apos',
		'<' => 'lt',
		'>' => 'gt'
	};

	public static String escapeIllegalCharacters(String parameter){
		if(String.isBlank(parameter))
			return Constants.EMPTY;
		String escapedParameter = parameter;
		for(String characterToEscape : ESCAPED_CHARACTERS.keySet())
			escapedParameter = escapedParameter.replaceAll(characterToEscape, '&' + ESCAPED_CHARACTERS.get(characterToEscape) + ';');
		return escapedParameter;
	}

	public static Dom.XmlNode getChildNode(String namespace, Dom.XmlNode node){
		Dom.XmlNode specifiedNode;
		if(node != null)
			for(Dom.XmlNode child : node.getChildElements()) if(child.getName() == namespace) specifiedNode = child;
		return specifiedNode;
	}
}