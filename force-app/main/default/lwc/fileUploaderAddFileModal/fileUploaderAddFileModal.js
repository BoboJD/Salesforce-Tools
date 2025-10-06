import { api, LightningElement, track } from 'lwc';
import { displaySuccessToast } from 'c/utils';
import label from './labels';

export default class FileUploaderAddFileModal extends LightningElement{
	@api recordId;
	@api utilityData;
	@api options;
	@api multiple = false;
	@track fieldsFileupload = {
		tlz__FileType__c: '',
		tlz__RecordId__c: '',
		tlz__PrivateFile__c: false
	};
	label = label;

	get jsonFileupload(){
		return JSON.stringify(this.fieldsFileupload);
	}

	get fileTypes(){
		if(this.options)
			return this.options;
		if(this.utilityData.fileTypes && this.utilityData.config)
			return this.utilityData.fileTypes.filter(fileType => this.isAllowedToBeSelected(fileType.value));
		return [];
	}

	isAllowedToBeSelected(fileType){
		return (this.utilityData.config.tlz__AvailableValues__c && this.utilityData.config.tlz__AvailableValues__c.includes(fileType))
			|| (this.utilityData.isAdmin && this.utilityData.config.tlz__AvailableValuesForAdmin__c && this.utilityData.config.tlz__AvailableValuesForAdmin__c.includes(fileType));
	}

	get selectedFileTypeIsVisibleOnlyAdmin(){
		return this.utilityData.config.tlz__AvailableValuesForAdmin__c?.includes(this.fieldsFileupload.tlz__FileType__c);
	}

	setFileType(e){
		this.fieldsFileupload.tlz__FileType__c = e.detail.value;
		if(this.utilityData?.isAdmin && this.selectedFileTypeIsVisibleOnlyAdmin)
			this.fieldsFileupload.tlz__PrivateFile__c = true;
	}

	setPrivateFile(e){
		this.fieldsFileupload.tlz__PrivateFile__c = e.detail.checked;
	}

	connectedCallback(){
		if(this.fileTypes.length === 1)
			this.fieldsFileupload.tlz__FileType__c = this.fileTypes[0].value;
		this.fieldsFileupload.tlz__RecordId__c = this.recordId;
	}

	dispatchHideModal(){
		this.dispatchEvent(new CustomEvent('hidemodal'));
	}

	handleSuccess(e){
		const { files } = e.detail;
		const contentDocumentIds = files.map(file => file.documentId);
		displaySuccessToast(this, label.File_sAdded);
		this.dispatchEvent(new CustomEvent('fileupload', { detail: { contentDocumentIds, files } }));
	}
}