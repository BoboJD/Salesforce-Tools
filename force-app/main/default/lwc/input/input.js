import { LightningElement, api, track } from 'lwc';
import { logError } from 'c/logFactory';
import { NavigationMixin } from 'lightning/navigation';
import {
	formatDate, formatDatetime, formatNumber, isEmpty, formatCurrency, getValue,
	displaySuccessToast, displaySpinner, hideSpinner, handleErrorForUser, recursiveDeepCopy
} from 'c/utils';
import deleteFile from '@salesforce/apex/FileUploaderController.deleteFile';
import l from './labels';

export default class Input extends NavigationMixin(LightningElement){
	@api type = 'text';
	@api unit;
	@api label;
	@api fieldLevelHelp;
	@api placeholder;
	@api form;
	@api fieldName;
	@api messageToggleActive;
	@api messageToggleInactive;
	@api dateStyle;
	@api checked;
	@api step;
	@api autocomplete;
	@api variant;
	@api min;
	@api minLength;
	@api max;
	@api maxLength;
	@api options;
	@api recordId;
	@api multiple = false;
	@api edit = false;
	@api readOnly = false;
	@api required = false;
	@api disabled = false;
	@api hideFile = false;
	@track modal = {
		fileUpload: { displayed: false }
	};
	hasError = false;
	isLoading = false;
	l = l;
	_value;
	_files = [];

	get value(){
		return this._value;
	}
	@api
	set value(value){
		this._value = value;
	}

	get files(){
		return this._files;
	}
	@api
	set files(files){
		this._files = recursiveDeepCopy(files);
	}

	get formElementClass(){
		const classes = [
			'slds-form-element',
			this.labelHidden ? '' : 'slds-form-element_stacked',
			this.readOnly ? 'slds-form-element_readonly' : 'slds-is-editing',
			this.edit ? 'slds-form-element_edit' : '',
			this.hasError || this.displayEmailInvalid ? 'slds-has-error' : ''
		];
		return classes.join(' ');
	}

	get inputType(){
		return this.type === 'percent' ? 'number' : this.type;
	}

	get inputUnit(){
		return this.type === 'percent' ? '%' : this.unit;
	}

	get lightningInput(){
		return this.template.querySelector('lightning-input');
	}

	get editTitle(){
		return `Modifier: ${this.label}`;
	}

	get readOnlyValue(){
		if(this.value){
			if(this.type === 'date')
				return formatDate(new Date(this.value));
			if(this.type === 'datetime')
				return formatDatetime(new Date(this.value));
			if(this.typeCurrency || this.typeNumber || this.typePercent){
				let minimumFractionDigits = this.step?.includes('.') ? this.step.split('.')[1].length : this.step ? parseInt(this.step) : 2;
				if(this.typeCurrency)
					return formatCurrency(this.value, minimumFractionDigits);
				if(this.typeNumber || this.typePercent){
					const formattedValue = formatNumber(this.value, minimumFractionDigits);
					if(this.inputUnit)
						return `${formattedValue} ${this.inputUnit}`;
					return formattedValue;
				}
			}
			return this.value;
		}
		return null;
	}

	get labelHidden(){
		return isEmpty(this.label)
			|| this.variant === 'label-hidden'
			|| this.labelInline;
	}

	get labelInline(){
		return this.variant === 'label-inline';
	}

	get typeNumber(){
		return this.inputType === 'number';
	}

	get typeCurrency(){
		return this.inputType === 'currency';
	}

	get typeCheckbox(){
		return this.type === 'checkbox';
	}

	get typePercent(){
		return this.inputType === 'percent';
	}

	get typeToggle(){
		return this.type === 'toggle';
	}

	get typeFile(){
		return this.type === 'file';
	}

	get typeEmail(){
		return this.type === 'email';
	}

	get typeRichtext(){
		return this.type === 'richtext';
	}

	get typeTextarea(){
		return this.type === 'textarea';
	}

	get defaultType(){
		return !this.typeCheckbox && !this.typeFile && !this.typeRichtext && !this.typeTextarea;
	}

	get inputRequired(){
		return this.required && !this.disabled && !this.readOnly;
	}

	get displayEdit(){
		return this.edit && !this.disabled;
	}

	get checkboxDisabled(){
		return this.disabled ? this.disabled : this.typeCheckbox && this.readOnly;
	}

	get errorMessage(){
		return this.typeFile ? l.UploadAtLeastOneFile : l.CompleteThisField;
	}

	get displayEmailInvalid(){
		return this.typeEmail && !this.emailValidityHandledBySalesforce && !this.emailValid;
	}

	get emailValidityHandledBySalesforce(){
		if(!this.value)
			return true;
		const sfEmailPattern = /^[^\s@]+@[^\s@]+$/;
		return !sfEmailPattern.test(this.value);
	}

	get emailValid(){
		if(this.value){
			const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			return emailPattern.test(this.value);
		}
		return false;
	}

	get inputVariant(){
		return this.typeToggle ? 'label-hidden' : this.variant;
	}

	get displayUploadButton(){
		if((this.multiple === false && this.files.length > 0) || this.readOnly)
			return false;
		return true;
	}

	@api
	reportValidity(){
		if(this.readOnly)
			return;
		if(!this.typeFile && !this.typeRichtext && !this.typeTextarea && !(this.typeEmail && this.emailValidityHandledBySalesforce))
			this.lightningInput?.reportValidity();
		const isValid = this.checkValidity();
		this.hasError = !isValid;
		if(this.hasError)
			this.dispatchEvent(new CustomEvent('invalidmsg'));
	}

	@api
	checkValidity(){
		if(this.inputRequired)
			return this.typeFile ? this.files?.length > 0
				: (this.typeCheckbox || this.typeToggle) ? this.checked
					: (this.typeRichtext || this.typeTextarea) ? !isEmpty(this.value)
						: this.typeEmail && !this.emailValidityHandledBySalesforce ? this.emailValid
							: this.lightningInput.checkValidity();
		return true;
	}

	displayFileUploadModal(){
		this.modal.fileUpload.displayed = true;
	}

	hideFileUploadModal(){
		this.modal.fileUpload.displayed = false;
	}

	dispatchEdit(){
		this.dispatchEvent(new CustomEvent('edit'));
	}

	dispatchValueChange(e){
		let parameters = {};
		if(this.typeFile || this.typeRichtext || this.typeTextarea)
			this.hasError = false;
		if(this.typeFile){
			parameters = {
				value: e.detail.contentDocumentIds,
				files: e.detail.files
			};
			this._files = this.files.concat(e.detail.files);
			this.hideFileUploadModal();
		}else{
			let value = e.target.value;
			if(this.typeNumber || this.typeCurrency){
				value = parseFloat(value.replace(/,/g, '.').replace(/[^\d|.|-]+/g, ''));
				if(isNaN(value))
					value = null;
			}
			parameters = {
				value: value,
				fieldName: this.fieldName,
				checked: e.target.checked
			};
		}
		this.dispatchEvent(new CustomEvent('valuechange', { detail: parameters }));
	}

	deleteFile(e){
		e.preventDefault();
		const contentDocumentId = e.currentTarget.dataset.documentId;
		if(this.hideFile){
			this.dispatchEvent(new CustomEvent('hidefile', { contentDocumentId: contentDocumentId }));
			this.removeFileFromFilesAndDispatchChange(contentDocumentId);
		}else{
			displaySpinner(this);
			deleteFile({ contentDocumentId: contentDocumentId }).then(result => {
				if(result.status !== 'SUCCESS')
					throw result.message;
				this.removeFileFromFilesAndDispatchChange(contentDocumentId);
				displaySuccessToast(this, l.FileDeleted);
				hideSpinner(this);
			}).catch(error => {
				logError('lwc/input/input.js', 'deleteFile', error);
				handleErrorForUser(this, error);
			});
		}
	}

	removeFileFromFilesAndDispatchChange(contentDocumentId){
		this._files = this.files.filter(file => file.documentId !== contentDocumentId);
		this.dispatchEvent(new CustomEvent('valuechange', {
			detail: {
				value: this.files.map(file => file.documentId),
				files: this.files
			}
		}));
	}

	previewFile(e){
		e.preventDefault();
		this[NavigationMixin.Navigate]({
			type: 'standard__namedPage',
			attributes: {
				pageName: 'filePreview'
			},
			state: {
				selectedRecordId: e.currentTarget.dataset.documentId
			}
		});
	}

	connectedCallback(){
		if(this.form && this.fieldName)
			this._value = getValue(this.form, this.fieldName);
		if(this.type === 'file' && this.value && this.value != null && JSON.stringify(this.value) !== '[]' && JSON.stringify(this.value).length > 0 && typeof this.value === 'object'){
			if(this.value[Object.keys(this.value)[0]] === 'object'){
				for(let v in this.value){
					if({}.hasOwnProperty.call(this.value, v)){
						this._files.push({
							documentId: v.documentId,
							name: v.title
						});
					}
				}
			}else{
				this._files.push({
					documentId: this.value.documentId,
					name: this.value.title
				});
			}
		}
	}
}