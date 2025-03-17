import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import HEIGHT_MANAGER from '@salesforce/resourceUrl/modalHeightManager';
import { displaySpinner, hideSpinner } from 'c/utils';
import label from './labels';

export default class ModalContainer extends LightningElement{
	// Public Properties
	@api theme;
	@api title;
	@api subtitle;
	@api message;
	@api closeLabel = label.Cancel;
	@api hideClose = false;
	@api hideConfirm = false;
	@api position = 'fixed';
	@api isLoading = false;
	@api noPadding = false;
	@api enableSpinner = false;
	@api hideSpinnerByDefault = false;

	// Private Properties
	_hideCloseIcon = false;
	_confirmLabel = label.Continue;
	_confirmDisabled = false;
	label = label;
	scrollingHeight = 0;
	_steps = [];
	_step = 0;
	numberOfSteps = 0;

	// Getters and Setters
	get containerClass(){
		return 'slds-modal__container'
			+ (this.position === 'relative' || this.position === 'action' ? ' slds-p-around_none' : '');
	}

	get headerClass(){
		const themeClass = this.theme ? `slds-theme_alert-texture slds-theme_${this.theme}` : '';
		return `slds-modal__header ${themeClass}`;
	}

	get contentClass(){
		return 'slds-modal__content slds-is-relative'
			+ (this.noPadding ? '' : '  slds-p-around_small')
			+ (this.position === 'fixed' ? ' min-content-height' : '');
	}

	get confirmLabel(){
		return this.multipleSteps && !this.isLastStep ? label.Next : this._confirmLabel;
	}

	@api
	set confirmLabel(confirmLabel){
		this._confirmLabel = confirmLabel;
	}

	get confirmDisabled(){
		return this._confirmDisabled || this.isLoading;
	}

	@api
	set confirmDisabled(value){
		this._confirmDisabled = value;
	}

	get hideCloseIcon(){
		return this._hideCloseIcon || this.position === 'action' || this.hideClose;
	}

	@api
	set hideCloseIcon(value){
		this._hideCloseIcon = value;
	}

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

	// Public Methods
	@api
	showSpinner(){
		displaySpinner(this, false);
	}

	@api
	hideSpinner(){
		hideSpinner(this, false);
		if(this.position === 'action'){ // fix to change the height of the modal
			setTimeout(() => {
				window.dispatchEvent(new Event('resize'));
			}, 1);
		}
	}

	@api
	incrementStep(){
		this.step++;
		this.template.querySelector('.slds-modal__content').scrollTop = 0;
	}

	// Callbacks
	connectedCallback(){
		this.updatePosition();
		if(this.position === 'action'){
			loadScript(this, HEIGHT_MANAGER).then(this.updateHeight.bind(this));
			window.addEventListener('resize', this.updateHeight.bind(this));
		}else{
			this.setupKeypressListener();
		}
	}

	disconnectedCallback(){
		if(this.position === 'action'){
			window.removeEventListener('resize', this.updateHeight.bind(this));
		}else{
			window.removeEventListener('keydown', this._watchKeypressComponent);
		}
	}

	// Private Methods
	setupKeypressListener(){
		this._watchKeypressComponent = this.watchKeypressComponent.bind(this);
		window.addEventListener('keydown', this._watchKeypressComponent);
	}

	updatePosition(){
		if(this.position === 'fixed'){
			this.template.host.classList.add('fixed-position');
		}else{
			this.template.host.classList.remove('fixed-position');
		}
	}

	updateHeight(){
		window.adjustModalHeight(this.template.host);
	}

	// Event Handlers
	watchKeypressComponent(e){
		if(e.key === 'Escape') this.dispatchCloseModal();
	}

	setScrollingHeight(e){
		this.scrollingHeight = e.target.scrollTop;
	}

	setStep(e){
		const newStep = this.steps.findIndex(step => step === e.target.value);
		if(newStep < this.step)
			this.step = newStep;
	}

	// Dispatch Events
	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}