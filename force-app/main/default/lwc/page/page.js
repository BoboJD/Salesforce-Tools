import{ LightningElement, api } from 'lwc';
import{ displaySpinner, hideSpinner } from 'c/utils';
import label from './labels';

export default class Page extends LightningElement{
	// Public Properties
	@api title;
	@api cancelLabel = label.Cancel;
	@api backDisabled = false;
	@api nextDisabled = false;
	@api hideSpinnerByDefault = false;
	@api fullWidth = false;
	@api hideNext = false;

	// Private Properties
	label = label;
	scrollingHeight = 0;
	_steps = [];
	_step = 0;
	numberOfSteps = 0;

	// Getters and Setters
	get steps(){
		return this._steps;
	}

	@api
	set steps(value){
		this._steps = value;
		this.numberOfSteps = this._steps.length;
	}

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
		return (this.numberOfSteps - 1) === this.step || this.numberOfSteps === 0;
	}

	get progressStepLabel(){
		return this.steps[this.step];
	}

	get multipleSteps(){
		return this.numberOfSteps > 1;
	}

	get nextLabel(){
		return this.isLastStep ? label.Save : label.Next;
	}

	get pageClass(){
		return 'page' + (this.fullWidth ? ' full-width' : '');
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

	// Callbacks
	connectedCallback(){
		this.template.addEventListener('registerscroll', this.handleRegisterScroll.bind(this));
		this.template.addEventListener('unregisterscroll', this.handleUnregisterScroll.bind(this));
	}

	disconnectedCallback(){
		this.template.removeEventListener('registerscroll', this.handleRegisterScroll);
		this.template.removeEventListener('unregisterscroll', this.handleUnregisterScroll);
	}

	// Event Handlers
	setScrollingHeight(e){
		this.scrollingHeight = e.target.scrollTop;
	}

	setStep(e){
		const newStep = this.steps.findIndex(step => step === e.target.value);
		if(newStep < this.step)
			this.step = newStep;
	}

	handleRegisterScroll(e){
		const scrollableContainer = this.template.querySelector('.slds-modal__content');
		if(scrollableContainer)
			scrollableContainer.addEventListener('scroll', e.detail.callback);
	}

	handleUnregisterScroll(e){
		const scrollableContainer = this.template.querySelector('.slds-modal__content');
		if(scrollableContainer)
			scrollableContainer.removeEventListener('scroll', e.detail.callback);
	}

	// Dispatch Events
	dispatchCancel(){
		this.dispatchEvent(new CustomEvent('cancel'));
	}

	doBack(){
		this.step--;
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