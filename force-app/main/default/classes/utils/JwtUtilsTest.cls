@IsTest
private class JwtUtilsTest{

	@IsTest
	static void validJwtShouldReturnPositiveMinutes(){
		DateTime now = DateTime.newInstanceGMT(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute(), System.now().second());
		DateTime exp = now.addMinutes(15);

		Long futureExp = exp.getTime() / 1000; // convert to Unix timestamp
		String payload = '{"exp":' + futureExp + '}';
		String jwt = buildFakeJwtWithPayload(payload);

		Integer minutes = JwtUtils.getJwtExpirationInMinutes(jwt);
		Assert.isTrue(minutes > 0);
	}

	@IsTest
	static void expiredJwtShouldReturnZero(){
		DateTime now = tlz.DateUtils.now();
		DateTime exp = now.addMinutes(-15);

		Long pastExp = exp.getTime() / 1000; // convert to Unix timestamp
		String payload = '{"exp":' + pastExp + '}';
		String jwt = buildFakeJwtWithPayload(payload);

		Integer minutes = JwtUtils.getJwtExpirationInMinutes(jwt);
		Assert.equals(0, minutes);
	}

	@IsTest
	static void jwtWithMissingExpShouldThrowError(){
		String payload = '{"iat":1234567890}';
		String jwt = buildFakeJwtWithPayload(payload);

		String errorMessage;
		try{
			JwtUtils.getJwtExpirationInMinutes(jwt);
		}catch(IllegalArgumentException e){
			errorMessage = e.getMessage();
		}
		Assert.messageContains(errorMessage, 'exp');
	}

	@IsTest
	static void malformedJwtShouldThrowError(){
		String invalidJwt = 'abc.def';

		String errorMessage;
		try{
			JwtUtils.getJwtExpirationInMinutes(invalidJwt);
		}catch(IllegalArgumentException e){
			errorMessage = e.getMessage();
		}
		Assert.messageContains(errorMessage, 'format');
	}

	private static String buildFakeJwtWithPayload(String jsonPayload){
		String header = '{"alg":"none"}';
		String encodedHeader = base64UrlEncode(header);
		String encodedPayload = base64UrlEncode(jsonPayload);
		return encodedHeader + '.' + encodedPayload + '.signature';
	}

	private static String base64UrlEncode(String str){
		String encoded = EncodingUtil.base64Encode(Blob.valueOf(str));
		return encoded.replace('+', '-').replace('/', '_').replace('=', '');
	}
}