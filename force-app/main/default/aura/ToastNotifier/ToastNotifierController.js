({
	listenToToastPlatformEvents: function(component, event, helper){
		const empApi = component.find('empApi');
		empApi.subscribe('/event/tlz__Toast__e', -1, $A.getCallback(eventReceived => {
			if($A.get('$SObjectType.CurrentUser.Id') == eventReceived.data.payload.CreatedById){
				helper.displaySuccessToast(eventReceived.data.payload.tlz__Message__c);
			}
		}));
	}
});