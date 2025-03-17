import { displayErrorToast } from './messagingUtils';
import { hideSpinner } from './spinnerUtils';

const hasNoApexError = (cmp, result) => {
	if(result.status !== 'SUCCESS'){
		if(!result.customError)
			throw result.message;
		displayErrorToast(cmp, result.message);
		hideSpinner(cmp);
		return false;
	}
	return true;
};

export {
	hasNoApexError
};