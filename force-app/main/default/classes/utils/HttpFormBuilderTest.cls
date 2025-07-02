@IsTest
private class HttpFormBuilderTest{

	@IsTest
	static void getContentTypeShouldNotReturnNull(){
		Assert.isNotNull(HttpFormBuilder.getContentType());
	}

	@IsTest
	static void writeBoundaryShouldNotReturnNull(){
		Assert.isNotNull(HttpFormBuilder.writeBoundary());
	}

	@IsTest
	static void writeEndShouldNotReturnNull(){
		Assert.isNotNull(HttpFormBuilder.writeEnd());
	}

	@IsTest
	static void writeFileShouldNotReturnNull(){
		Assert.isNotNull(HttpFormBuilder.writeFile('file', 'fileName', 'txt', Blob.valueOf('file')));
	}

	@IsTest
	static void writeBodyParameterShouldNotReturnNull(){
		Assert.isNotNull(HttpFormBuilder.writeBodyParameter('file', 'fileName'));
	}
}