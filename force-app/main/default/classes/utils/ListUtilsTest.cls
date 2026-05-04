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

	@IsTest
	static void toIdListWithNullShouldReturnEmptyList(){
		List<Id> ids = ListUtils.toIdList(null);
		Assert.isNotNull(ids);
		Assert.isTrue(ids.isEmpty());
	}

	@IsTest
	static void toIdListWithBlankStringsShouldSkipThem(){
		List<String> strings = new List<String>{'', '  ', null};
		List<Id> ids = ListUtils.toIdList(strings);
		Assert.isTrue(ids.isEmpty());
	}

	@IsTest
	static void toIdListWithValidIdStrings(){
		Id userId = UserInfo.getUserId();
		List<String> strings = new List<String>{(String)userId};
		List<Id> ids = ListUtils.toIdList(strings);
		Assert.equals(1, ids.size());
		Assert.equals(userId, ids[0]);
	}
}