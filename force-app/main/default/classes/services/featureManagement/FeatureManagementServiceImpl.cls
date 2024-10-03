global inherited sharing class FeatureManagementServiceImpl implements IFeatureManagementService{

	global Boolean checkPermission(String permissionName){
		return FeatureManagement.checkPermission(permissionName);
	}

	global Boolean bypassChatterNotification(){
		return checkPermission(PermissionConstants.BYPASS_CHATTER_NOTIFICATION);
	}

	global Boolean bypassValidationRules(){
		return checkPermission(PermissionConstants.BYPASS_VALIDATION_RULES);
	}
}