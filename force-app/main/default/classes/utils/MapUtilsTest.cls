@IsTest
private class MapUtilsTest{

	@IsTest
	static void getWithNullMapShouldReturnNull(){
		Map<String, Object> parentNode = null;
		List<String> childNodes = new List<String>();

		Test.startTest();
		Object value = MapUtils.get(parentNode, childNodes);
		Test.stopTest();

		Assert.isNull(value);
	}

	@IsTest
	static void getWithNullChildNodesShouldReturnNull(){
		Map<String, Object> parentNode = new Map<String, Object>();
		List<String> childNodes = null;

		Test.startTest();
		Object value = MapUtils.get(parentNode, childNodes);
		Test.stopTest();

		Assert.isNull(value);
	}

	@IsTest
	static void getWithEmptyChildNodesShouldReturnNull(){
		Map<String, Object> parentNode = new Map<String, Object>();
		List<String> childNodes = new List<String>();

		Test.startTest();
		Object value = MapUtils.get(parentNode, childNodes);
		Test.stopTest();

		Assert.isNull(value);
	}

	@IsTest
	static void getChildNodeOfChildNodeShouldReturnDecimal(){
		Map<String, Object> parentNode = new Map<String, Object>{
			'child' => new Map<String, Decimal>{
				'decimalValue' => 2
			}
		};
		List<String> childNodes = new List<String>{ 'child', 'decimalValue' };

		Test.startTest();
		Decimal value = (Decimal)MapUtils.get(parentNode, childNodes);
		Test.stopTest();

		Assert.equals(2, value);
	}
}