import { LightningElement, track, api } from 'lwc';
import { displaySpinner, hideSpinner, displaySuccessToast, downloadFile, displayErrorToast } from 'c/utils';
import { loadStyle } from 'lightning/platformResourceLoader';
import { FilterOption } from 'c/filter';
import fileUploaderCss from '@salesforce/resourceUrl/fileUploaderCss';
import apex from './apex';
import label from './labels';

export default class FileUploader extends LightningElement{
	@api recordId;
	@api hideAddFiles = false;
	@api hideDate = false;
	@api massDeleteOption = false;
	@track utilityData = { files: [] };
	@track modal = {
		addFile: { displayed: false }
	};
	@track filter = {};
	label = label;

	get filteredFiles(){
		if(this.utilityData.files.length)
			return this.utilityData.files.filter(file => this.hasFileTypeIncludedInFilter(file) && this.hasExtensionIncludedInFilter(file));
		return [];
	}

	hasFileTypeIncludedInFilter(file){
		if(this.filter.fileTypes?.value?.length)
			return this.filter.fileTypes.value.includes(file.type);
		return true;
	}

	hasExtensionIncludedInFilter(file){
		if(this.filter.extensions?.value?.length)
			return this.filter.extensions.value.includes(file.extension);
		return true;
	}

	get displayFilterBtn(){
		return this.filter.fileTypes?.options?.length > 1 || this.filter.extensions?.options?.length > 1;
	}

	get hasSelectedFiles(){
		return this.utilityData.files.filter(file => file.selected).length;
	}

	setFilter(e){
		this.filter = e.detail.filter;
	}

	setSelected(e){
		const { fileId, checked } = e.detail;
		this.utilityData.files.forEach(file => {
			if(file.id === fileId)
				file.selected = checked;
		});
	}

	connectedCallback(){
		loadStyle(this, fileUploaderCss);
		apex.getUtilityData(this, { recordId: this.recordId }, utilityData => {
			this.utilityData = utilityData;
			this.initFilter();
			hideSpinner(this);
		});
	}

	initFilter(){
		this.filter.fileTypes = FilterOption.newCheckbox(label.FileTypes);
		this.filter.extensions = FilterOption.newCheckbox('Extensions');
		if(this.utilityData.files.length){
			const typesAlreadyAdded = new Set();
			const extentionsAlreadyAdded = new Set();
			this.utilityData.files.forEach(file => {
				if(file.type && !typesAlreadyAdded.has(file.type)){
					this.filter.fileTypes.options.push({ value: file.type, label: file.type });
					typesAlreadyAdded.add(file.type);
				}
				if(file.extension && !extentionsAlreadyAdded.has(file.extension)){
					this.filter.extensions.options.push({ value: file.extension, label: file.extension });
					extentionsAlreadyAdded.add(file.extension);
				}
			});
		}
	}

	downloadEveryFiles(){
		this.filteredFiles.forEach(file => downloadFile(file.id));
	}

	displayAddFileModal(){
		this.modal.addFile.displayed = true;
	}

	hideAddFileModal(){
		this.modal.addFile.displayed = false;
	}

	hideAddFileModalAndRefreshFiles(){
		this.hideAddFileModal();
		this.refreshFiles();
	}

	downloadFile(e){
		const { contentVersionId } = e.detail;
		this.dispatchEvent(new CustomEvent('opensubtab', { detail: { recordId: contentVersionId } }));
	}

	deleteFile(e){
		const { contentDocumentLinkId, title } = e.detail;
		const filesToDelete = this.utilityData.files.filter(file => file.contentDocumentLinkId === contentDocumentLinkId);
		const filesToDeleteJSON = JSON.stringify(filesToDelete);
		displaySpinner(this);
		apex.deleteFiles(this, { filesToDeleteJSON }, () => {
			displaySuccessToast(this, format(label.File_0_deleted, [title]));
			this.refreshFiles();
		});
	}

	refreshFiles(){
		displaySpinner(this);
		apex.getFiles(this, { recordId: this.recordId }, files => {
			this.utilityData.files = files;
			hideSpinner(this);
		});
	}

	deleteFiles(){
		const filesToDelete = this.utilityData.files.filter(file => file.selected);
		if(this.mandatSigneBeingDeletedOnAccount(filesToDelete)){
			displayErrorToast(this, label.ErreurSuppressionMandatSigne);
		}else{
			const filesToDeleteJSON = JSON.stringify(filesToDelete);
			displaySpinner(this);
			apex.deleteFiles(this, { filesToDeleteJSON }, () => {
				displaySuccessToast(this, label.FilesDeleted);
				hideSpinner(this);
				this.refreshFiles();
			});
		}
	}
}