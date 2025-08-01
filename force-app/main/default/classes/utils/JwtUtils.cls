global class JwtUtils{

	global static Long getJwtExpirationInMinutes(String jwt){
		String payloadJson = extractPayloadJson(jwt);
		Long exp = extractExpirationTimestamp(payloadJson);
		return calculateMinutesUntilExpiration(exp);
	}

	private static String extractPayloadJson(String jwt){
		List<String> parts = jwt.split('\\.');
		if(parts.size()!= 3)
			throw new IllegalArgumentException('Invalid JWT format');
		String payloadEncoded = parts[1];
		String base64Payload = payloadEncoded.replace('-', '+').replace('_', '/');
		while (Math.mod(base64Payload.length(), 4) != 0){
			base64Payload += '=';
		}
		try{
			Blob payloadBlob = EncodingUtil.base64Decode(base64Payload);
			return payloadBlob.toString();
		}catch (Exception e){
			throw new IllegalArgumentException('Failed to decode JWT payload: ' + e.getMessage());
		}
	}

	private static Long extractExpirationTimestamp(String payloadJson){
		Map<String, Object> payloadMap = (Map<String, Object>)JSON.deserializeUntyped(payloadJson);
		if(!payloadMap.containsKey('exp'))
			throw new IllegalArgumentException('JWT does not contain exp field');
		return (Long)payloadMap.get('exp');
	}

	private static Long calculateMinutesUntilExpiration(Long expTimestamp){
		Integer expSeconds = (Integer)expTimestamp.intValue();
		DateTime epoch = DateTime.newInstanceGMT(1970, 1, 1, 0, 0, 0);
		DateTime expDateTime = epoch.addSeconds(expSeconds);
		DateTime now = tlz.DateUtils.now();
		Long minutesLeft = (expDateTime.getTime() - now.getTime()) / (1000 * 60);
		return Math.max(minutesLeft, 0);
	}
}