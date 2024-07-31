import { api, LightningElement, track } from 'lwc';
import { displaySuccessToast } from 'c/utils';
import label from './labels';

export default class FileUploaderAddFileModal extends LightningElement{
	@api recordId;
	@api utilityData;
	@api options;
	@api multiple = false;
	@track fieldsFileupload = {
		Type__c: '',
		RecordId__c: '',
		PrivateFile__c: false
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
		return (this.utilityData.config.AvailableValues__c && this.utilityData.config.AvailableValues__c.includes(fileType))
			|| (this.utilityData.isAdmin && this.utilityData.config.AvailableValuesForAdmin__c && this.utilityData.config.AvailableValuesForAdmin__c.includes(fileType));
	}

	get selectedFileTypeIsVisibleOnlySiege(){
		return this.utilityData.config.AvailableValuesForAdmin__c?.includes(this.fieldsFileupload.Type__c);
	}

	setFileType(e){
		this.fieldsFileupload.Type__c = e.detail.value;
		if(this.utilityData?.isAdmin && this.selectedFileTypeIsVisibleOnlySiege)
			this.fieldsFileupload.PrivateFile__c = true;
	}

	setPrivateFile(e){
		this.fieldsFileupload.PrivateFile__c = e.detail.checked;
	}

	connectedCallback(){
		this.setupKeypressListener();
		if(this.fileTypes.length === 1)
			this.fieldsFileupload.Type__c = this.fileTypes[0].value;
		this.fieldsFileupload.RecordId__c = this.recordId;
	}

	setupKeypressListener(){
		this._watchKeypressComponent = this.watchKeypressComponent.bind(this);
		window.addEventListener('keydown', this._watchKeypressComponent);
	}

	watchKeypressComponent(e){
		if(e.key === 'Escape') this.dispatchHideModal();
	}

	disconnectedCallback(){
		window.removeEventListener('keydown', this._watchKeypressComponent);
	}

	dispatchHideModal(){
		this.dispatchEvent(new CustomEvent('hidemodal'));
	}

	handleSuccess(e){
		const { files }  = e.detail;
		const contentDocumentIds = files.map(file => file.documentId);
		displaySuccessToast(this, label.File_sAdded);
		this.dispatchEvent(new CustomEvent('fileupload', { detail: { contentDocumentIds, files } }));
	}
}