import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import label from './labels';

export default class FileUploaderCard extends NavigationMixin(LightningElement){
	@api file;
	@api displayDeleteBtn = false;
	@api hideDate = false;
	@api massDeleteOption = false;
	displayMenu = false;
	label = label;

	get isExcel(){
		return this.file.extension && this.file.extension.toLowerCase().includes('xls');
	}

	get displayCreatedDate(){
		return !this.hideDate && this.file.createdDate;
	}

	get displaySelection(){
		return this.displayDeleteBtn && this.massDeleteOption;
	}

	filePreview(){
		this[NavigationMixin.Navigate]({
			type: 'standard__namedPage',
			attributes: {
				pageName: 'filePreview'
			},
			state: {
				selectedRecordId: this.file.documentId
			}
		});
	}

	dispatchSelection(e){
		this.dispatchEvent(new CustomEvent('selection', {
			detail: {
				fileId: this.file.id,
				checked: e.detail.checked
			}
		}));
	}

	downloadFile(){
		this.displayMenu = false;
		this.dispatchEvent(new CustomEvent('downloadfile', {
			detail: {
				contentVersionId: this.file.id
			}
		}));
	}

	deleteFile(){
		this.displayMenu = false;
		this.dispatchEvent(new CustomEvent('deletefile', {
			detail: {
				title: this.file.title,
				contentDocumentLinkId: this.file.contentDocumentLinkId
			}
		}));
	}

	toggleMenu(){
		this.displayMenu = !this.displayMenu;
	}
}