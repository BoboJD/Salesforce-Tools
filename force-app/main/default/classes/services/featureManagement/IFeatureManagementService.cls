global interface IFeatureManagementService{
	Boolean checkPermission(String permissionName);
	Boolean bypassChatterNotification();
	Boolean bypassValidationRules();
}