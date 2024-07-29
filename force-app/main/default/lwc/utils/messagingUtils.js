import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const displayToast = (cmp, variant, title, message='') => {
	cmp.dispatchEvent(new ShowToastEvent({ variant, title, message }));
};

const displayErrorToast = (cmp, title, message) => {
	displayToast(cmp, 'error', title, message);
};

const displaySuccessToast = (cmp, title, message) => {
	displayToast(cmp, 'success', title, message);
};

const displayWarningToast = (cmp, title, message) => {
	displayToast(cmp, 'warning', title, message);
};

const displayInfoToast = (cmp, title, message) => {
	displayToast(cmp, 'info', title, message);
};

export {
	displayToast,
	displayErrorToast,
	displaySuccessToast,
	displayWarningToast,
	displayInfoToast
};