public inherited sharing class FeatureManagementServiceImpl implements IFeatureManagementService{

	public Boolean checkPermission(String permissionName){
		return FeatureManagement.checkPermission(permissionName);
	}
}