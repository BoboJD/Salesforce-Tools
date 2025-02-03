import { LightningElement, api } from 'lwc';
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
		displaySpinner(this, false);
	}

	@api
	hideSpinner(){
		hideSpinner(this, false);
	}

	// Private Methods
	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}