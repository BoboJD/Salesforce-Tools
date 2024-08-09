global without sharing class TokenManager{
	private static final Integer MAX_DURATION_OF_TRANSACTION = 1; // in minutes
	private static TokenManager instance;
	@TestVisible private Map<String, String> tokenByService = new Map<String, String>();

	private Cache.OrgPartition orgPartition{
		get{
			if(orgPartition == null)
				orgPartition = Cache.Org.getPartition('AccessToken');
			return orgPartition;
		}set;
	}

	global static Boolean tokenIsExpiredFor(String serviceName){
		return !getInstance().orgPartition.contains(serviceName+'Token');
	}

	global static String getToken(String serviceName){
		TokenManager instance = getInstance();
		if(!instance.tokenByService.containsKey(serviceName))
			instance.tokenByService.put(serviceName, (String)instance.orgPartition.get(serviceName+'Token'));
		return instance.tokenByService.get(serviceName);
	}

	global static void setToken(String serviceName, String accessToken){
		setToken(serviceName, accessToken, null);
	}

	global static void setToken(String serviceName, String accessToken, Integer durationOfTokenInMinutes){
		if(durationOfTokenInMinutes == null){
			TokenManager__mdt tokenSetting = TokenManager__mdt.getInstance(serviceName);
			if(tokenSetting == null)
				throw new CustomException('Record "' + serviceName + '" is not created in the custom metadata "Token Manager".');
			durationOfTokenInMinutes = Integer.valueOf((Decimal)tokenSetting.ExpireAfter__c);
		}
		Integer tokenExpiracyInSeconds = (durationOfTokenInMinutes - MAX_DURATION_OF_TRANSACTION) * 60;
		if(tokenExpiracyInSeconds > 172800) tokenExpiracyInSeconds = 172800; // Salesforce limit max to store token
		getInstance().orgPartition.put(serviceName+'Token', accessToken, tokenExpiracyInSeconds);
		getInstance().tokenByService.put(serviceName, accessToken);
	}

	@TestVisible
	private static TokenManager getInstance(){
		if(instance == null)
			instance = new TokenManager();
		return instance;
	}
}