@IsTest
private class XmlUtilsTest{

	@IsTest
	static void escapeIllegalCharactersShouldReplaceBadCharacter(){
		String badCharacters = 'Test &"\'><';
		
		Test.startTest();
		String escapedCharacters = XmlUtils.escapeIllegalCharacters(badCharacters);
		Test.stopTest();

		Assert.equals('Test &amp;&quot;&apos;&gt;&lt;', escapedCharacters);
	}

	@IsTest
	static void escapeIllegalCharactersWithNullParameterShouldReturnNull(){
		Test.startTest();
		String escapedCharacters = XmlUtils.escapeIllegalCharacters(null);
		Test.stopTest();

		Assert.equals('', escapedCharacters);
	}

	@IsTest
	static void getChildNodeShouldReturnOneChildNode(){
		Dom.Document doc = new Dom.Document();
		Dom.XmlNode products = doc.createRootElement('products', null, null);
		Dom.XmlNode product = products.addChildElement('product', null, null);

		Test.startTest();
		Dom.XmlNode childNodeReturned = XmlUtils.getChildNode('product', products);
		Test.stopTest();

		Assert.equals(product, childNodeReturned);
	}

	@IsTest
	static void getChildNodeShouldReturnNull(){
		Dom.Document doc = new Dom.Document();
		Dom.XmlNode products = doc.createRootElement('products', null, null);

		Test.startTest();
		Dom.XmlNode childNodeReturned = XmlUtils.getChildNode('test', products);
		Test.stopTest();

		Assert.isNull(childNodeReturned);
	}
}