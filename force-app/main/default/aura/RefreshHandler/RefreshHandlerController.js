({
	listenToToastPlatformEvents: function(component){
		const empApi = component.find('empApi');
		empApi.subscribe('/event/tlz__Refresh__e', -1, $A.getCallback(eventReceived => {
			if($A.get('$SObjectType.CurrentUser.Id') == eventReceived.data.payload.CreatedById){
				$A.get('e.force:refreshView').fire();
			}
		}));
	}
});