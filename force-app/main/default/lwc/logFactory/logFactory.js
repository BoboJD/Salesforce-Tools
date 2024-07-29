import commitError from '@salesforce/apex/LogFactoryController.commitError';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { stringifyError, isDisconnectedError } from 'c/utils';

const logError = (componentName, method, errors) => {
	if(isDisconnectedError(errors))
		return;
	commitError({
		errorJSON: JSON.stringify({
			url: window.location.href,
			formFactor: FORM_FACTOR,
			componentName,
			method,
			details: stringifyError(errors)
		})
	});
};

export { logError };