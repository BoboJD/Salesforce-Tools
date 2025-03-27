@RestResource(urlMapping='/findDuplicates')
global without sharing class DatacloudServiceRest{

	@HttpPost
	global static void findDuplicates(){
		try{
			SObject sObj = (SObject)JSON.deserialize(RestContext.request.requestBody.toString(), SObject.class);
			List<SObject> duplicates = DatacloudService.findDuplicates(sObj);
			RestContext.response.statusCode = 200;
			RestContext.response.responseBody = Blob.valueOf(JSON.serialize(duplicates));
		}catch(Exception e){
			RestContext.response.statusCode = 500;
			RestContext.response.responseBody = Blob.valueOf(e.getMessage());
		}
	}
}