public without sharing class DatacloudService{

	public static List<SObject> findDuplicates(SObject record){
		return service().findDuplicates(record);
	}

	private static IDatacloudService service(){
		return (IDatacloudService)Application.Service.newInstance(IDatacloudService.class);
	}
}