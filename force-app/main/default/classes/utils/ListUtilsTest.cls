@IsTest
private class ListUtilsTest{

	@IsTest
	static void lastWithNullListShouldReturnNull(){
		List<String> strings;
		String lastString = (String)ListUtils.last(strings);
		Assert.isNull(lastString);
	}

	@IsTest
	static void lastWithEmptyListShouldReturnNull(){
		List<String> strings = new List<String>();
		String lastString = (String)ListUtils.last(strings);
		Assert.isNull(lastString);
	}

	@IsTest
	static void lastWithListShouldReturnLastRow(){
		List<String> strings = new List<String>{'1', '2'};
		String lastString = (String)ListUtils.last(strings);
		Assert.equals('2', lastString);
	}
}