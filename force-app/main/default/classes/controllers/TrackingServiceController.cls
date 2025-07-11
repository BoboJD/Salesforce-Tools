global without sharing class TrackingServiceController{

	@AuraEnabled
	global static Map<String, Object> commitTracking(String functionality){
		Map<String, Object> result = new Map<String, Object>();
		try{
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ Tracking__c.SObjectType });
			uow.registerNew(new Tracking__c(Functionality__c = functionality));
			uow.commitWork();
			result = ControllerUtils.success();
		}catch(Exception e){
			LogFactory.commitError(TrackingServiceController.class, 'commitTracking', new List<Object>{ functionality }, e);
			result = ControllerUtils.error(e);
		}
		return result;
	}
}