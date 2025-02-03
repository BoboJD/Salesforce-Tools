import { LightningElement, api } from 'lwc';
import { displaySpinner, hideSpinner } from 'c/utils';
import label from './labels';

export default class Modal extends LightningElement{
	// Public Properties
	@api theme;
	@api title;
	@api subtitle;
	@api message;
	@api confirmLabel = label.Continue;
	@api isLoading = false;
	@api noPadding = false;
	@api hideConfirm = false;
	@api enableSpinner = false;
	@api hideSpinnerByDefault = false;

	// Getters and Setters
	get noMessage(){
		return !this.message;
	}

	// Public Methods
	@api
	showSpinner(){
		displaySpinner(this);
	}

	@api
	hideSpinner(){
		hideSpinner(this);
	}

	// Private Methods
	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}