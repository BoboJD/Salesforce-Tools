const toggleSpinner = (cmp, action, selectors) => {
	selectors.forEach(selector => {
		const element = cmp.template.querySelector(selector);
		element?.[action]();
	});
};

const displaySpinner = (cmp, watchForTlzComponents=true) => {
	cmp.isLoading = true;
	if(watchForTlzComponents)
		toggleSpinner(cmp, 'showSpinner', ['c-page', 'tlz-page', 'c-modal', 'tlz-modal', 'c-modal-container', 'tlz-modal-container']);
	toggleSpinner(cmp, 'show', ['c-spinner', 'tlz-spinner']);
};

const hideSpinner = (cmp, watchForTlzComponents=true) => {
	cmp.isLoading = false;
	if(watchForTlzComponents)
		toggleSpinner(cmp, 'hideSpinner', ['c-page', 'tlz-page', 'c-modal', 'tlz-modal', 'c-modal-container', 'tlz-modal-container']);
	toggleSpinner(cmp, 'hide', ['c-spinner', 'tlz-spinner']);
};

export {
	displaySpinner,
	hideSpinner
};