import AnErrorOccurredContactAnAdministrator from '@salesforce/label/c.AnErrorOccurredContactAnAdministrator';
import ErrorLossOfInternetConnection from '@salesforce/label/c.ErrorLossOfInternetConnection';
import ErrorProcessingFailed from '@salesforce/label/c.ErrorProcessingFailed';
import displayTrueError from '@salesforce/customPermission/ErrorMessageVisible';
import { hideSpinner } from './spinnerUtils';
import { displayErrorToast, displayInfoToast, displayWarningToast } from './messagingUtils';
import { containsAtLeastOneOfTheTerms } from './stringUtils';

const stringifyError = error => {
	return error instanceof Error ? JSON.stringify(error, Object.getOwnPropertyNames(error)) : JSON.stringify(error);
};

const retrieveCustomValidationException = errorString => {
	return errorString.split('\n')
		.filter(line => line.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION'))
		.map(line => line.split('FIELD_CUSTOM_VALIDATION_EXCEPTION: ')[1])
		.join('\n');
};

const extractValidationRuleMessageFromError = error => {
	try{
		const errorJSON = stringifyError(error);
		if(errorJSON.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION,'))
			return errorJSON.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,')[1].split(':')[0];
		if(error.message)
			return retrieveCustomValidationException(error.message);
		if(error.stack)
			return retrieveCustomValidationException(error.stack);
		return retrieveCustomValidationException(error);
	}catch(err){ /* empty */ }
	return null;
};

const errorContainsDuplicatesException = error => {
	try{
		const errorJSON = stringifyError(error);
		return errorJSON.includes('DUPLICATES_DETECTED');
	}catch(err){ /* empty */ }
	return false;
};

const errorContainsUnableToLockRowException = error => {
	if(error){
		try{
			const errorJSON = stringifyError(error);
			return errorJSON.includes('UNABLE_TO_LOCK_ROW');
		}catch(err){ /* empty */ }
	}
	return false;
};

const isDisconnectedError = error => {
	if(error){
		try{
			const errorJSON = stringifyError(error);
			return errorJSON.includes('Disconnected')
				|| (errorJSON.includes('fetchResponse') && errorJSON.includes('Server Error') && !errorJSON.includes('message'))
				|| errorJSON.includes('Communication error, please retry or reload the page');
		}catch(err){ /* empty */ }
	}
	return false;
};

const retrieveErrorMessage = error => {
	return error?.message || error?.body?.message || ErreurMerciDeContacterVotreAdministrateur;
};

const retrieveStackTrace = error => {
	return error?.stackTrace || error?.body?.stackTrace || '';
};

const handleErrorForUser = (cmp, error) => {
	if(isDisconnectedError(error)){
		displayInfoToast(cmp, ErrorLossOfInternetConnection);
	}else if(errorContainsUnableToLockRowException(error)){
		displayWarningToast(cmp, ErrorProcessingFailed);
	}else{
		const errorMessage = displayTrueError ? retrieveErrorMessage(error) : ErreurMerciDeContacterVotreAdministrateur;
		const stackTrace = displayTrueError ? retrieveStackTrace(error) : '';
		displayErrorToast(cmp, errorMessage, stackTrace);
	}
	hideSpinner(cmp);
};

const displayErrorAndHideSpinner = (cmp, errorMessage) => {
	displayErrorToast(cmp, errorMessage);
	hideSpinner(cmp);
};

const errorCanBeLogged = (error, customErrorsNotToLog) => {
	const errorMessage = stringifyError(error);
	return !containsAtLeastOneOfTheTerms(errorMessage, customErrorsNotToLog);
};

export {
	extractValidationRuleMessageFromError,
	stringifyError,
	errorContainsDuplicatesException,
	errorContainsUnableToLockRowException,
	isDisconnectedError,
	handleErrorForUser,
	displayErrorAndHideSpinner,
	errorCanBeLogged
};