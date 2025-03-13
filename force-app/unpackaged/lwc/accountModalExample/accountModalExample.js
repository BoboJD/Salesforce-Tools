import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { displaySpinner, wait, hideSpinner, checkRequiredFields, displayErrorToast, setValue } from 'c/utils';

export default class AccountModalExample extends LightningElement{
	@track form = { email: 'test@test.fr' };
	recordId;
	isLoading = true;

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

	get chartConfig(){
		return {
			type: 'polarArea',
			data: {
				labels: [
					'Red',
					'Green',
					'Yellow',
					'Grey',
					'Blue'
				],
				datasets: [{
					label: 'My First Dataset',
					data: [11, 16, 7, 3, 14],
					backgroundColor: [
						'rgb(255, 99, 132)',
						'rgb(75, 192, 192)',
						'rgb(255, 205, 86)',
						'rgb(201, 203, 207)',
						'rgb(54, 162, 235)'
					]
				}]
			}
		};
	}

	get modalContainer(){
		return this.template.querySelector('c-modal-container');
	}

	connectedCallback(){
		setTimeout(() => {
			hideSpinner(this);
		}, 2000);
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
		}
	}

	formIsValid(){
		return checkRequiredFields(this);
	}
}