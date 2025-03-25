global without sharing class RefreshEventPublisherController{

	@AuraEnabled
	global static void publishRefreshEvent(){
		EventBus.publish(new Refresh__e());
	}
}