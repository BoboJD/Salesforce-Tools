const functionExist = (input, functionName) => {
	return typeof input[functionName] !== 'undefined' && typeof input[functionName] === 'function';
};

const checkRequiredFields = (cmp, otherSelectors) => {
	let allValid = true;
	const lightningComponents = 'lightning-checkbox-group,lightning-radio-group,lightning-input,lightning-combobox,lightning-dual-listbox';
	const customLightningComponents = 'c-input,c-lookup,c-picklist,tlz-input,tlz-lookup,tlz-picklist';
	let selectors = customLightningComponents + ',' + lightningComponents + (otherSelectors ? ','+otherSelectors : '');
	let inputs = cmp.template.querySelectorAll(selectors);
	if(inputs?.length > 0){
		inputs.forEach(input => {
			if(functionExist(input, 'reportValidity'))
				input.reportValidity();
			if(!input.checkValidity())
				allValid = false;
		});
	}
	return allValid;
};

const setValue = (form, property, value) => {
	let currentObj = form;
	if(property.includes('.')){
		const nestedProperties = property.split('.');
		const lastProperty = nestedProperties.pop();
		for(const nestedProperty of nestedProperties){
			if(!currentObj[nestedProperty])
				currentObj[nestedProperty] = {};
			currentObj = currentObj[nestedProperty];
		}
		setValue(currentObj, lastProperty, value);
	}else{
		currentObj[property] = value;
	}
};

const getValue = (form, property) => {
	let currentObj = form;
	if(property.includes('.')){
		const nestedProperties = property.split('.');
		const lastProperty = nestedProperties.pop();
		for(const nestedProperty of nestedProperties){
			if(!currentObj[nestedProperty])
				currentObj[nestedProperty] = {};
			currentObj = currentObj[nestedProperty];
		}
		return getValue(currentObj, lastProperty);
	}
	return currentObj[property];
};

const wait = seconds => {
	return new Promise(resolve => setTimeout(resolve, seconds * 1000));
};

export {
	functionExist,
	checkRequiredFields,
	setValue,
	getValue,
	wait
};