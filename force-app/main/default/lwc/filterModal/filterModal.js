import { api, LightningElement } from 'lwc';
import { recursiveDeepCopy, objectHasNotChanged } from 'c/utils';
import label from './labels';

export default class FilterModal extends LightningElement{
	initialFilter;
	_filter;
	label = label;

	@api set filter(filter){
		this._filter = recursiveDeepCopy(filter);
	}

	get filter(){
		return this._filter;
	}

	get sections(){
		const sections = [];
		for(let filterOption in this.filter){
			if({}.hasOwnProperty.call(this.filter, filterOption)){
				const section = this.filter[filterOption];
				section.filterOption = filterOption;
				sections.push(section);
			}
		}
		return sections;
	}

	setFilterOptionValue(e){
		this.filter[e.detail.filterOption].value = e.detail.value;
	}

	connectedCallback(){
		this.initialFilter = recursiveDeepCopy(this.filter);
		this.setupKeypressListener();
	}

	setupKeypressListener(){
		this._closeModalOnEscapeKeyPushed = this.closeModalOnEscapeKeyPushed.bind(this);
		window.addEventListener('keydown', this._closeModalOnEscapeKeyPushed);
	}

	closeModalOnEscapeKeyPushed(e){
		if(e.key === 'Escape')
			this.dispatchCloseModal();
	}

	disconnectedCallback(){
		window.removeEventListener('keydown', this._closeModalOnEscapeKeyPushed);
	}

	dispatchCloseModal(){
		this.dispatchEvent(new CustomEvent('closemodal'));
	}

	dispatchApply(){
		if(objectHasNotChanged(this.initialFilter, this.filter))
			this.dispatchCloseModal();
		else{
			this.dispatchEvent(new CustomEvent('apply', {
				detail: {
					filter: this.filter
				}
			}));
		}
	}
}