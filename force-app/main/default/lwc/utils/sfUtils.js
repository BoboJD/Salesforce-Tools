import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { generateUrl } from "lightning/fileDownload";

const downloadFile = fileId => {
	window.open(generateUrl(fileId));
};

const refreshRecord = recordId => {
	notifyRecordUpdateAvailable([{ recordId }]);
};

export {
	downloadFile,
	refreshRecord
};