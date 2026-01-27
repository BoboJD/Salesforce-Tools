import { LightningElement, wire, track } from 'lwc';
import { IsConsoleNavigation } from 'lightning/platformWorkspaceApi';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { createRecord } from 'lightning/uiRecordApi';
import { displaySpinner, wait, hideSpinner, checkRequiredFields, displayErrorToast, displaySuccessToast, setValue, refreshView } from 'c/utils';
import { query, countQuery, getSObjectList, getFieldsForSObject } from 'c/soqlService';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class AccountModalExample extends NavigationMixin(LightningElement){
	@wire(IsConsoleNavigation) isConsoleNavigation;
	@track form = {
		firstName: 'a',
		lastName: 'b',
		email: 'c@c.fr',
		phone: '06 06 06 06 06'
	};
	recordId;
	isLoading = true;
	displayNextRow = false;
	previousFormHeight;

	// soqlService example properties
	accountCount = 0;
	@track accounts = [];
	sObjectCount = 0;
	@track accountFields = [];

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference){
		if(currentPageReference)
			this.recordId = currentPageReference.state.recordId;
	}

	get steps(){
		return ['Contact Information'];
	}

	get types(){
		return [
			{ value: 'A', label: 'A' },
			{ value: 'B', label: 'B' },
			{ value: 'C', label: 'C' },
			{ value: 'D', label: 'D' },
			{ value: 'E', label: 'E' },
			{ value: 'F', label: 'F' },
			{ value: 'G', label: 'G' },
			{ value: 'H', label: 'H' }
		];
	}

	get chartConfig(){
		return {
			type: 'line',
			data: {
				labels: ['2024-01', '2024-02', '2024-03', '2024-04', '2024-05', '2024-06', '2024-07', '2024-08', '2024-09', '2024-10', '2024-11', '2024-12'],
				datasets: [
					{
						label: 'Dataset 1',
						data: [10, 20, 15, 25, 30, 22, 35, 40, 38, 50, 55, 60],
						borderColor: 'rgba(75, 192, 192, 1)',
						backgroundColor: 'rgba(75, 192, 192, 0.2)',
						fill: true,
						tension: 0.3
					},
					{
						label: 'Dataset 2',
						data: [5, 15, 10, 20, 25, 18, 30, 32, 28, 45, 50, 58],
						borderColor: 'rgba(255, 99, 132, 1)',
						backgroundColor: 'rgba(255, 99, 132, 0.2)',
						fill: true,
						tension: 0.3
					}
				]
			},
			options: {
				responsive: true,
				scales: {
					xAxes: [{
						type: 'time',
						time: {
							unit: 'month',
							unitStepSize: 1,
							displayFormats: {
								'month': 'MMM-YYYY'
							}
						},
						scaleLabel: {
							display: true,
							labelString: 'Date'
						}
					}],
					yAxes: [{
						ticks: {
							beginAtZero: true
						}
					}]
				}
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
		this.loadSoqlServiceExamples();
	}

	async loadSoqlServiceExamples(){
		// Example 1: Count query
		const countResult = await countQuery('SELECT COUNT() FROM Account');
		if(countResult.status === 'SUCCESS'){
			this.accountCount = countResult.count;
		}

		// Example 2: Query records
		const queryResult = await query('SELECT Id, Name FROM Account LIMIT 5');
		if(queryResult.status === 'SUCCESS'){
			this.accounts = queryResult.records;
		}

		// Example 3: Get list of SObjects
		const sObjects = await getSObjectList();
		this.sObjectCount = sObjects.length;

		// Example 4: Get fields for Account
		const fields = await getFieldsForSObject('Account');
		this.accountFields = fields.slice(0, 5); // Just show first 5 fields
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

	handleFieldChange(e){
		const { fieldName, value } = e.detail;
		setValue(this.form, fieldName, value);
	}

	async submitForm(){
		if(!this.formIsValid()){
			displayErrorToast(this, 'Please fill in all required fields.');
			return;
		}

		try{
			displaySpinner(this);
			await createRecord({
				apiName: CONTACT_OBJECT.objectApiName,
				fields: {
					FirstName: this.form.firstName,
					LastName: this.form.lastName,
					Email: this.form.email,
					Phone: this.form.phone,
					AccountId: this.recordId
				}
			});
			refreshView(this);
			displaySuccessToast(this, 'Contact created successfully');
			this.closeQuickAction();
		}catch(error){
			displayErrorToast(this, 'Error creating contact: ' + error.body.message);
		}finally{
			hideSpinner(this);
		}
	}

	formIsValid(){
		return checkRequiredFields(this);
	}
}