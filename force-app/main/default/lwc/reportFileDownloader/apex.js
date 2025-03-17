import { logError } from 'c/logFactory';
import { handleErrorForUser, hasNoApexError } from 'c/utils';
import getUtilityData from '@salesforce/apex/ReportFileDownloaderController.getUtilityData';
import downloadReportFiles from '@salesforce/apex/ReportFileDownloaderController.downloadReportFiles';

const handleError = (cmp, error, context) => {
	logError('lwc/reportFileDownloader/apex.js', context, error);
	handleErrorForUser(cmp, error);
};

export default {
	getUtilityData: (cmp, onfulfilled) => {
		getUtilityData()
			.then(onfulfilled)
			.catch(error => {
				handleError(cmp, error, 'getUtilityData');
			});
	},

	downloadReportFiles: (cmp, params, onfulfilled) => {
		downloadReportFiles(params)
			.then(result => {
				if(hasNoApexError(cmp, result))
					onfulfilled(result.fileIds);
			})
			.catch(error => {
				handleError(cmp, error, 'downloadReportFiles');
			});
	}
};