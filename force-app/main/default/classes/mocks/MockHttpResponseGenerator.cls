@IsTest
global class MockHttpResponseGenerator implements HttpCalloutMock{
	private String contentType;
	private String body;
	private String fileName;
	private Blob bodyAsBlob;
	private Integer statusCode;

	private MockHttpResponseGenerator(String contentType, String body, Integer statusCode){
		this.contentType = contentType;
		this.body = body;
		this.statusCode = statusCode;
	}

	private MockHttpResponseGenerator(String contentType, Integer statusCode, String fileName, Blob bodyAsBlob){
		this.contentType = contentType;
		this.fileName = fileName;
		this.bodyAsBlob = bodyAsBlob;
		this.statusCode = statusCode;
	}

	global static MockHttpResponseGenerator initStringResponse(String contentType, Integer statusCode, String body){
		return new MockHttpResponseGenerator(contentType, body, statusCode);
	}

	global static MockHttpResponseGenerator initFileResponse(String contentType, Integer statusCode, String fileName, Blob fileData){
		return new MockHttpResponseGenerator(contentType, statusCode, fileName, fileData);
	}

	global HttpResponse respond(HttpRequest req){
		HttpResponse res = new HttpResponse();
		setHeaders(res);
		res.setStatusCode(statusCode);
		setBody(res);
		return res;
	}

	private void setHeaders(HttpResponse res){
		if(String.isNotBlank(contentType))
			res.setHeader(WebserviceConstants.CONTENT_TYPE, contentType);
		if(String.isNotBlank(fileName))
			res.setHeader(WebserviceConstants.CONTENT_DISPOSITION, 'filename='+fileName);
	}

	private void setBody(HttpResponse res){
		if(String.isNotBlank(body))
			res.setBody(body);
		else if(bodyAsBlob != null)
			res.setBodyAsBlob(bodyAsBlob);
	}
}