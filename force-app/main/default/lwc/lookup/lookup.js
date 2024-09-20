import { LightningElement, track, api } from 'lwc';
import { recursiveDeepCopy, isEmpty } from 'c/utils';
import search from '@salesforce/apex/LookupController.search';
import l from './labels';

export default class Lookup extends LightningElement{
	@api label;
	@api placeholder = `${l.Search}...`;
	@api iconName;
	@api variant;
	@api required = false;
	@api disabled = false;
	@api readOnly = false;
	@api edit = false;
	@api sObjectApiName;
	@api searchFieldApiName = 'Name';
	@api valueFieldApiName = 'Id';
	@api mainFieldDisplayed = 'Name';
	@api additionalFieldsDisplayed;
	@api additionalFields;
	@api additionalSearchFieldsApiName;
	@api additionalCondition;
	@api nbResultMax = 5;
	@api notExactResult = false;
	@track searchResults = [];
	displayInvalidMsg = false;
	searchedTerm;
	_selectedSearchResult;
	_value;
	l = l;

	get selectedSearchResult(){
		return this._selectedSearchResult;
	}
	@api
	set selectedSearchResult(selectedSearchResult){
		this._selectedSearchResult = recursiveDeepCopy(selectedSearchResult);
	}

	get value(){
		return this._value;
	}
	@api
	set value(value){
		this._value = value;
	}

	@api
	reportValidity(){
		const isValid = this.checkValidity();
		this.displayInvalidMsg = !isValid;
		if(!isValid)
			this.dispatchEvent(new CustomEvent('invalidmsg'));
	}

	@api
	checkValidity(){
		if(this.inputRequired)
			return !isEmpty(this.value);
		return true;
	}

	get labelHidden(){
		return isEmpty(this.label)
			|| this.variant === 'label-hidden'
			|| this.labelInline;
	}

	get formElementClass(){
		const classes = [
			'slds-form-element',
			this.labelHidden ? '' : 'slds-form-element_stacked',
			this.readOnly ? 'slds-form-element_readonly' : 'slds-is-editing',
			this.edit ? 'slds-form-element_edit' : '',
			this.hasError ? 'slds-has-error' : ''
		];
		return classes.join(' ');
	}

	get comboboxContainerClass(){
		return 'slds-combobox_container' + (this.selectedSearchResult ? ' slds-has-selection' : '');
	}

	get comboboxClass(){
		return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click' + (this.searchResults.length > 0 ? ' slds-is-open' : '');
	}

	get comboboxFormElementClass(){
		return 'slds-combobox__form-element slds-input-has-icon '
			+ (this.selectedSearchResult && this.iconName ? 'slds-input-has-icon_left-right' : 'slds-input-has-icon_right');
	}

	get hasError(){
		const isValid = this.checkValidity();
		return !isValid && this.displayInvalidMsg;
	}

	get displayRemove(){
		return !this.disabled && !this.readOnly;
	}

	get editTitle(){
		return `Modifier: ${this.label}`;
	}

	get inputRequired(){
		return this.required && !this.readOnly && !this.disabled;
	}

	performSearch(e){
		this.searchedTerm = e.target.value;
		if(this.searchedTerm && this.searchedTerm.length > 2){
			const criteriaJSON = JSON.stringify({
				sObjectApiName: this.sObjectApiName,
				searchFieldApiName: this.searchFieldApiName,
				searchedTerm: this.notExactResult ? '%' + this.searchedTerm : this.searchedTerm,
				nbResultMax: this.nbResultMax,
				valueFieldApiName: this.valueFieldApiName,
				mainFieldDisplayed: this.mainFieldDisplayed,
				additionalFieldsDisplayed: this.additionalFieldsDisplayed,
				additionalFields: this.additionalFields,
				additionalSearchFieldsApiName: this.additionalSearchFieldsApiName,
				additionalCondition: this.additionalCondition
			});
			search({ criteriaJSON }).then(searchResults => { this.searchResults = searchResults; });
		}else{
			this.searchResults = [];
		}
	}

	selectItem(e){
		const index = parseInt(e.detail.index, 10);
		this._selectedSearchResult = this.searchResults[index];
		this._value = this.selectedSearchResult.value;
		this.searchResults = [];
		this.dispatchValueChange();
	}

	dispatchValueChange(){
		this.dispatchEvent(new CustomEvent('valuechange', {
			detail: {
				selectedSearchResult: this.selectedSearchResult,
				value: this.value
			}
		}));
	}

	removeSelectedSearchResult(){
		this._selectedSearchResult = null;
		this._value = null;
		this.dispatchValueChange();
	}

	dispatchEdit(){
		this.dispatchEvent(new CustomEvent('edit'));
	}
}