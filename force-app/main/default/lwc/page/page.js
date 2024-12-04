import{ LightningElement, api } from 'lwc';
import{ displaySpinner, hideSpinner } from 'c/utils';
import label from './labels';

export default class Page extends LightningElement{
	// Public Properties
	@api title;
	@api steps = [];
	@api nextDisabled = false;

	// Private Properties
	label = label;
	scrollingHeight = 0;
	_step = 0;

	// Getters and Setters
	get step(){
		return this._step;
	}

	@api
	set step(value){
		this._step = value;
	}

	@api
	get isFirstStep(){
		return this.step === 0;
	}

	@api
	get isSecondStep(){
		return this.step === 1;
	}

	@api
	get isLastStep(){
		return (this.steps.length - 1) === this.step;
	}

	get progressStepLabel(){
		return this.steps[this.step];
	}

	get multipleSteps(){
		return this.steps.length > 1;
	}

	get nextLabel(){
		return this.isLastStep ? label.Save : label.Next;
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

	@api
	incrementStep(){
		this.step++;
		this.template.querySelector('.slds-modal__content').scrollTop = 0;
	}

	// Event Handlers
	setScrollingHeight(e){
		this.scrollingHeight = e.target.scrollTop;
	}

	setStep(e){
		const newStep = parseInt(e.target.value, 10);
		if(newStep < this.step){
			this.step = newStep;
		}
	}

	// Dispatch Events
	dispatchCancel(){
		this.dispatchEvent(new CustomEvent('cancel'));
	}

	dispatchNext(){
		this.dispatchEvent(new CustomEvent('next', {
			detail: {
				step: this.step,
				isFirstStep: this.isFirstStep,
				isLastStep: this.isLastStep
			}
		}));
	}
}