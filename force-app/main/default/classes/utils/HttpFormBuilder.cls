@SuppressWarnings('PMD.ExcessiveParameterList')
global class HttpFormBuilder{
	private static final String BOUNDARY = '1ff13444ed8140c7a32fc4e6451aa76d';

	global static String getContentType(){
		return 'multipart/form-data; charset="UTF-8"; boundary="' + BOUNDARY + '"';
	}

	global static String writeBoundary(){
		return EncodingUtil.convertToHex(Blob.valueOf('--' + BOUNDARY + '\r\n'));
	}

	global static String writeEnd(){
		return EncodingUtil.convertToHex(Blob.valueOf('\r\n--' + BOUNDARY + '--'));
	}

	global static String writeFile(String key, String filename, String mimeType, Blob fileBlob){
		String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"; filename="' + filename + '"\r\n';
		String contentType = 'Content-Type: ' + mimeType + '\r\n\r\n';
		return EncodingUtil.convertToHex(Blob.valueOf(contentDisposition))
			+ EncodingUtil.convertToHex(Blob.valueOf(contentType))
			+ EncodingUtil.convertToHex(fileBlob);
	}

	global static String writeBodyParameter(String key, String value){
		String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"\r\n\r\n';
		return EncodingUtil.convertToHex(Blob.valueOf(contentDisposition))
			+ EncodingUtil.convertToHex(Blob.valueOf(value + '\r\n'));
	}
}