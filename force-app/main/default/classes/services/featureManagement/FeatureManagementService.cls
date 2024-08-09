global inherited sharing class FeatureManagementService{

	global static Boolean checkPermission(String permissionName){
		return service().checkPermission(permissionName);
	}

	private static IFeatureManagementService service(){
		return (IFeatureManagementService)Application.Service.newInstance(IFeatureManagementService.class);
	}
}