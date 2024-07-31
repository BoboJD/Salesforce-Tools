import { LightningElement, api } from 'lwc';
import label from './labels';

export default class Modal extends LightningElement{
	@api theme;
	@api title;
	@api message;
	@api confirmLabel = label.Continue;
	@api noPadding = false;

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