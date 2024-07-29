import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

const downloadFile = fileId => {
	window.open(`/sfc/servlet.shepherd/version/download/${fileId}?asPdf=false&operationContext=CHATTER`);
};

const refreshRecord = recordId => {
	notifyRecordUpdateAvailable([{ recordId }]);
};

export {
	downloadFile,
	refreshRecord
};