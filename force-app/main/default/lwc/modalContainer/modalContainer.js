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
	@api confirmLabel = label.Continue;
	@api hideConfirm = false;
	@api position = 'fixed';
	@api isLoading = false;
	@api noPadding = false;
	@api enableSpinner = false;
	@api hideSpinnerByDefault = false;

	// Private Properties
	_hideCloseIcon = false;
	_confirmDisabled = false;
	label = label;
	scrollingHeight = 0;

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

	get confirmDisabled(){
		return this._confirmDisabled || this.isLoading;
	}

	@api
	set confirmDisabled(value){
		this._confirmDisabled = value;
	}

	get hideCloseIcon(){
		return this._hideCloseIcon || this.position === 'action';
	}

	@api
	set hideCloseIcon(value){
		this._hideCloseIcon = value;
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

	// Callbacks
	connectedCallback(){
		this.setupKeypressListener();
		this.updatePosition();
		if(this.position === 'action'){
			loadScript(this, HEIGHT_MANAGER).then(this.updateHeight.bind(this));
			window.addEventListener('resize', this.updateHeight.bind(this));
		}
	}

	disconnectedCallback(){
		window.removeEventListener('keydown', this._watchKeypressComponent);
		if(this.position === 'action'){
			window.removeEventListener('resize', this.updateHeight.bind(this));
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

	// Dispatch Events
	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}