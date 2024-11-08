import { LightningElement, api } from 'lwc';
import label from './labels';

export default class ModalContainer extends LightningElement{
	@api theme;
	@api title;
	@api subtitle;
	@api message;
	@api closeLabel = label.Cancel;
	@api confirmLabel = label.Continue;
	@api hideCloseIcon = false;
	@api hideConfirm = false;
	@api position = 'fixed';
	@api isLoading = false;
	@api noPadding = false;
	_confirmDisabled = false;
	label = label;

	get containerClass(){
		return 'slds-modal__container'
			+ (this.position === 'relative' ? ' slds-p-around_none' : '');
	}

	get headerClass(){
		const themeClass = this.theme ? `slds-theme_alert-texture slds-theme_${this.theme}` : '';
		return `slds-modal__header ${themeClass}`;
	}

	get contentClass(){
		return 'slds-modal__content slds-is-relative'
			+ (this.noPadding ? '' : '  slds-p-around_small');
	}

	get confirmDisabled(){
		return this._confirmDisabled || this.isLoading;
	}
	@api
	set confirmDisabled(value){
		this._confirmDisabled = value;
	}

	connectedCallback(){
		this.setupKeypressListener();
		this.updatePosition();
	}

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

	watchKeypressComponent(e){
		if(e.key === 'Escape') this.dispatchCloseModal();
	}

	disconnectedCallback(){
		window.removeEventListener('keydown', this._watchKeypressComponent);
	}

	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchConfirm(){
		this.dispatchEvent(new CustomEvent('confirm'));
	}
}