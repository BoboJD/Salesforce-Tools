import { LightningElement, api } from 'lwc';
import label from './labels';

export default class Modal extends LightningElement{
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

	get noMessage(){
		return !this.message;
	}

	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}