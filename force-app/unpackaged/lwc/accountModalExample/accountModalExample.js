import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { displaySpinner, wait, hideSpinner, checkRequiredFields, displayErrorToast, setValue } from 'c/utils';

export default class AccountModalExample extends LightningElement{
	@track form = { email: 'test@test.fr' };
	recordId;
	isLoading = true;
	displayNextRow = false;
	previousFormHeight;

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference){
		if(currentPageReference)
			this.recordId = currentPageReference.state.recordId;
	}

	get steps(){
		return ['Page 1', 'Page 2'];
	}

	get types(){
		return [
			{ value: 'A', label: 'A' },
			{ value: 'B', label: 'B' },
			{ value: 'C', label: 'C' }
		];
	}

	get modalContainer(){
		return this.template.querySelector('c-modal-container');
	}

	connectedCallback(){
		setTimeout(() => {
			hideSpinner(this);
		}, 2000);
	}

	renderedCallback(){
		if(this.formDiv)
			return;
		this.formDiv = this.template.querySelector('.slds-form');
		if(this.formDiv){
			const observer = new MutationObserver(() => {
				this.checkFormHeightChange();
			});
			observer.observe(this.formDiv, { childList: true, subtree: true, attributes: true, characterData: true });
		}
	}

	disconnectedCallback(){
		if(this.formDiv){
			const observer = new MutationObserver(() => {});
			observer.disconnect();
		}
	}

	checkFormHeightChange(){
		const currentHeight = this.formDiv.scrollHeight;
		if(currentHeight !== this.previousFormHeight){
			this.previousFormHeight = currentHeight;
			this.modalContainer.updateModalHeight();
		}
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
		const { fieldName, value } = e.detail;
		setValue(this.form, fieldName, value);
	}

	submitForm(){
		if(!this.formIsValid()){
			displayErrorToast(this, 'Vérifier les informations du contact.');
		}else{
			this.modalContainer.incrementStep();
			this.displayNextRow = true;
		}
	}

	formIsValid(){
		return checkRequiredFields(this);
	}
}