const PAGE = 'c-page';
const SPINNER = 'c-spinner';

const displaySpinner = cmp => {
	cmp.isLoading = true;
	cmp.template.querySelector(PAGE)?.showSpinner();
	cmp.template.querySelector(SPINNER)?.show();
};

const hideSpinner = cmp => {
	cmp.isLoading = false;
	cmp.template.querySelector(PAGE)?.hideSpinner();
	cmp.template.querySelector(SPINNER)?.hide();
};

export {
	displaySpinner,
	hideSpinner
};