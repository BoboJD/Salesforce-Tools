import { logError } from 'c/logFactory';
import { handleErrorForUser, hasNoApexError } from 'c/utils';
import updateFileType from '@salesforce/apex/FileUploaderController.updateFileType';

const handleError = (cmp, error, context) => {
	logError('lwc/fileUploaderEditTypeModal/apex.js', context, error);
	handleErrorForUser(cmp, error);
};

export default {
	updateFileType: (cmp, params, onfulfilled) => {
		updateFileType(params)
			.then(result => {
				if(hasNoApexError(cmp, result))
					onfulfilled();
			})
			.catch(error => {
				handleError(cmp, error, 'updateFileType');
			});
	}
};