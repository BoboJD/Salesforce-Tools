import { logError } from 'c/logFactory';
import { handleErrorForUser, hasNoApexError } from 'c/utils';
import getUtilityData from '@salesforce/apex/FileUploaderController.getUtilityData';
import deleteFiles from '@salesforce/apex/FileUploaderController.deleteFiles';
import getFiles from '@salesforce/apex/FileUploaderController.getFiles';

const handleError = (cmp, error, context) => {
	logError('lwc/fileUploader/apex.js', context, error);
	handleErrorForUser(cmp, error);
};

export default {
	getUtilityData: (cmp, params, onfulfilled) => {
		getUtilityData(params)
			.then(onfulfilled)
			.catch(error => {
				handleError(cmp, error, 'getUtilityData');
			});
	},

	deleteFiles: (cmp, params, onfulfilled) => {
		deleteFiles(params)
			.then(result => {
				if(hasNoApexError(cmp, result))
					onfulfilled();
			})
			.catch(error => {
				handleError(cmp, error, 'deleteFiles');
			});
	},

	getFiles: (cmp, params, onfulfilled) => {
		getFiles(params)
			.then(onfulfilled)
			.catch(error => {
				handleError(cmp, error, 'getFiles');
			});
	}
};