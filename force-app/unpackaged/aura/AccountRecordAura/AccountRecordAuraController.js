({
	doInit: function(component){
		var options = [
			{ label: 'Option 1', value: 'option1' },
			{ label: 'Option 2', value: 'option2' },
			{ label: 'Option 3', value: 'option3' }
		];
		component.set('v.options', options);
	},

	handleValueChange: function(component, event){
		var selectedValue = event.getParam('value');
		component.set('v.selectedValue', selectedValue);
	}
});