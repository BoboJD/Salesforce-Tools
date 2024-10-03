global inherited sharing class FeatureManagementService{

	global static Boolean checkPermission(String permissionName){
		return service().checkPermission(permissionName);
	}

	global static Boolean bypassChatterNotification(){
		return service().bypassChatterNotification();
	}

	global static Boolean bypassValidationRules(){
		return service().bypassValidationRules();
	}

	private static IFeatureManagementService service(){
		return (IFeatureManagementService)Application.Service.newInstance(IFeatureManagementService.class);
	}
}