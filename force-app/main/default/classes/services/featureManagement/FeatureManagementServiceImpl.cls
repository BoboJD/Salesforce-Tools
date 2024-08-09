global inherited sharing class FeatureManagementServiceImpl implements IFeatureManagementService{

	global Boolean checkPermission(String permissionName){
		return FeatureManagement.checkPermission(permissionName);
	}
}