import { LightningElement, track } from 'lwc';
import { hideSpinner, downloadFile, displaySpinner } from 'c/utils';
import label from './labels';
import apex from './apex';

export default class ReportFileDownloader extends LightningElement{
	@track utilityData;
	@track form = {};
	isLoading = true;

	get label(){
		return {
			...label,
			...this.utilityData ? this.utilityData.label : {}
		};
	}

	get downloadDisabled(){
		return !this.form.reportId || this.isLoading;
	}

	setReportId(e){
		this.form.reportId = e.detail.value;
	}

	setFileType(e){
		this.form.fileType = e.detail.value;
	}

	connectedCallback(){
		apex.getUtilityData(this, utilityData => {
			this.utilityData = utilityData;
			hideSpinner(this);
		});
	}

	getDownloadLinkReportFiles(){
		displaySpinner(this);
		apex.downloadReportFiles(this, { formJSON: JSON.stringify(this.form) }, fileIds => {
			fileIds.forEach(fileId => {
				downloadFile(fileId);
			});
			hideSpinner(this);
		});
	}
}