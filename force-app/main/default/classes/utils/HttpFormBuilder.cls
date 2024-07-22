@SuppressWarnings('PMD.ExcessiveParameterList')
public class HttpFormBuilder{
	
	private static final String BOUNDARY = '1ff13444ed8140c7a32fc4e6451aa76d';

	public static String getContentType(){
		return 'multipart/form-data; charset="UTF-8"; boundary="' + BOUNDARY + '"';
	}

	public static String writeBoundary(){
		return EncodingUtil.convertToHex(Blob.valueOf('--' + BOUNDARY + '\r\n'));
	}

	public static String writeEnd(){
		return EncodingUtil.convertToHex(Blob.valueOf('\r\n--' + BOUNDARY + '--'));
	}

	public static String writeFile(String key, String filename, String mimeType, Blob fileBlob){
		String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"; filename="' + filename + '"\r\n';
		String contentType = 'Content-Type: ' + mimeType + '\r\n\r\n';
		return EncodingUtil.convertToHex(Blob.valueOf(contentDisposition))
			+ EncodingUtil.convertToHex(Blob.valueOf(contentType))
			+ EncodingUtil.convertToHex(fileBlob);
	}

	public static String writeBodyParameter(String key, String value){
		String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"\r\n\r\n';
		return EncodingUtil.convertToHex(Blob.valueOf(contentDisposition))
			+ EncodingUtil.convertToHex(Blob.valueOf(value + '\r\n'));
	}
}