global without sharing class DatacloudService{

	global static List<SObject> findDuplicates(SObject record){
		return service().findDuplicates(record);
	}

	private static IDatacloudService service(){
		return (IDatacloudService)Application.Service.newInstance(IDatacloudService.class);
	}
}