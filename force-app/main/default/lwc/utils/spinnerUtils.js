const toggleSpinner = (cmp, action, selectors) => {
	selectors.forEach(selector => {
		const element = cmp.template.querySelector(selector);
		element?.[action]();
	});
};

const displaySpinner = cmp => {
	cmp.isLoading = true;
	toggleSpinner(cmp, 'showSpinner', ['c-page', 'tlz-page']);
	toggleSpinner(cmp, 'show', ['c-spinner', 'tlz-spinner']);
};

const hideSpinner = cmp => {
	cmp.isLoading = false;
	toggleSpinner(cmp, 'hideSpinner', ['c-page', 'tlz-page']);
	toggleSpinner(cmp, 'hide', ['c-spinner', 'tlz-spinner']);
};

export {
	displaySpinner,
	hideSpinner
};