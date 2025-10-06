import { api, LightningElement } from 'lwc';
import { displaySuccessToast, checkRequiredFields, displaySpinner } from 'c/utils';
import label from './labels';
import apex from './apex';

export default class FileUploaderEditTypeModal extends LightningElement{
	@api contentVersionId;
	@api utilityData;
	selectedFileType;
	label = label;

	get fileTypes(){
		if(this.utilityData.fileTypes && this.utilityData.config)
			return this.utilityData.fileTypes.filter(fileType => this.isAllowedToBeSelected(fileType.value));
		return [];
	}

	isAllowedToBeSelected(fileType){
		return (this.utilityData.config.tlz__AvailableValues__c && this.utilityData.config.tlz__AvailableValues__c.includes(fileType))
			|| (this.utilityData.isAdmin && this.utilityData.config.tlz__AvailableValuesForAdmin__c && this.utilityData.config.tlz__AvailableValuesForAdmin__c.includes(fileType));
	}

	setSelectedFileType(e){
		this.selectedFileType = e.detail.value;
	}

	dispatchHideModal(){
		this.dispatchEvent(new CustomEvent('hidemodal'));
	}

	submitNewFileType(){
		if(this.formIsValid()){
			displaySpinner(this);
			apex.updateFileType(this, { contentVersionId: this.contentVersionId, fileType: this.selectedFileType }, () => {
				displaySuccessToast(this, label.FileTypeUpdated);
				this.dispatchEvent(new CustomEvent('submitsuccess'));
			});
		}
	}

	formIsValid(){
		return checkRequiredFields(this);
	}
}