import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { displaySpinner, wait, hideSpinner, checkRequiredFields, displayErrorToast } from 'c/utils';

export default class AccountModalExample extends LightningElement{
	recordId;
	isLoading = true;
	email;

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference){
		if(currentPageReference)
			this.recordId = currentPageReference.state.recordId;
	}

	connectedCallback(){
		this.isLoading = false;
	}

	closeQuickAction(){
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	async toggleSpinner(){
		displaySpinner(this);
		await wait(3);
		hideSpinner(this);
	}

	setEmail(e){
		this.email = e.detail.value;
	}

	submitForm(){
		if(!this.formIsValid()){
			displayErrorToast(this, 'Vérifier les informations du contact.');
		}
	}

	formIsValid(){
		return checkRequiredFields(this);
	}
}