public without sharing class TrackingServiceController{

	@AuraEnabled
	public static Map<String, Object> commitTracking(String functionality){
		Map<String, Object> result = new Map<String, Object>();
		try{
			fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ Tracking__c.SObjectType });
			uow.registerNew(new Tracking__c(Functionality__c = functionality));
			uow.commitWork();
			result.put(Constants.STATUS, Constants.SUCCESS);
		}catch(Exception e){
			LogFactory.commitError(TrackingServiceController.class, 'commitTracking', new List<Object>{ functionality }, e);
			result.put(Constants.STATUS, Constants.ERROR);
			result.put(Constants.MESSAGE, e.getMessage());
		}
		return result;
	}
}