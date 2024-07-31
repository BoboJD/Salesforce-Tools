import { api, LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import filterCss from '@salesforce/resourceUrl/filterCss';
import label from './labels';

export default class Filter extends LightningElement{
	@api filter;
	displayModal = false;
	label = label;

	connectedCallback(){
		loadStyle(this, filterCss);
		this.setupClickListener();
	}

	setupClickListener(){
		this._closeModalOnClickOutside = this.closeModal.bind(this);
		window.addEventListener('click', this._closeModalOnClickOutside);
	}

	disconnectedCallback(){
		window.removeEventListener('click', this._closeModalOnClickOutside);
	}

	toggleModal(){
		this.displayModal = !this.displayModal;
	}

	preventToTriggerCloseModal(e){
		e.stopPropagation();
		return false;
	}

	closeModal(){
		this.displayModal = false;
	}

	dispatchApplyThenCloseModal(e){
		this.dispatchEvent(new CustomEvent('apply', {
			detail: {
				filter: e.detail.filter
			}
		}));
		this.closeModal();
	}
}

export * from './filterOption';