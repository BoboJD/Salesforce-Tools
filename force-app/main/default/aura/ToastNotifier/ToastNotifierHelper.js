({
	displaySuccessToast: function(message){
		const toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({ type: 'success', message });
		toastEvent.fire();
	}
});