@IsTest
private class ControllerUtilsTest{

	@IsTest
	static void successShouldReturnStatusSuccess(){
		Map<String, Object> result = ControllerUtils.success();
		Assert.equals(Constants.SUCCESS, result.get(Constants.STATUS));

		result = ControllerUtils.success('test', 'value');
		Assert.equals(Constants.SUCCESS, result.get(Constants.STATUS));
		Assert.equals('value', result.get('test'));

		result = ControllerUtils.success(new Map<String, Object>{'test' => 'value'});
		Assert.equals(Constants.SUCCESS, result.get(Constants.STATUS));
		Assert.equals('value', result.get('test'));
	}

	@IsTest
	static void errorShouldReturnStatusError(){
		Map<String, Object> result = ControllerUtils.error(new CustomException('error message'));
		Assert.equals(Constants.ERROR, result.get(Constants.STATUS));
		Assert.isTrue(result.get(Constants.CUSTOM_ERROR));
		Assert.equals('error message', result.get(Constants.MESSAGE));

		result = ControllerUtils.error('error message');
		Assert.equals(Constants.ERROR, result.get(Constants.STATUS));
		Assert.isTrue(result.get(Constants.CUSTOM_ERROR));
		Assert.equals('error message', result.get(Constants.MESSAGE));
	}
}