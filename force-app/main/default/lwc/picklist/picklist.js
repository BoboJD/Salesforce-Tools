import { LightningElement, api, track } from 'lwc';
import { recursiveDeepCopy, isEmpty, format } from 'c/utils';
import l from './labels';

export default class Picklist extends LightningElement{
	@api type = 'picklist';
	@api label;
	@api fieldLevelHelp;
	@api placeholder = l.SelectAnOption;
	@api variant;
	@api sourceLabel;
	@api selectedLabel;
	@api fieldName;
	@api max;
	@api form;
	@api searchable = false;
	@api edit = false;
	@api required = false;
	@api readOnly = false;
	@api disabled = false;
	@api selectAllOption = false;
	@api displaySelection = false;
	@api addNewRecordOption = false;
	@api newRecordOptionLabel = l.NewRecord;
	@api disabledValues = [];
	filteredTerm;
	isOpened = false;
	displayInvalidMsg = false;
	_multiple = false;
	isBeingFocused = false;
	l = l;

	_options = [];
	@track _value;

	get options(){
		return this._options;
	}
	@api
	set options(options){
		this._options = recursiveDeepCopy(options);
	}

	get value(){
		return this._value;
	}
	@api
	set value(value){
		this._value = recursiveDeepCopy(value);
	}

	get multiple(){
		return this._multiple;
	}
	@api
	set multiple(multiple){
		this._multiple = multiple;
	}

	@api
	reportValidity(){
		const isValid = this.isDual ? this.lightningDualListbox.reportValidity() : this.checkValidity();
		this.displayInvalidMsg = !isValid && !this.isDual;
		if(!isValid)
			this.dispatchEvent(new CustomEvent('invalidmsg'));
	}

	@api
	checkValidity(){
		if(this.inputRequired)
			return this.value?.length > 0;
		return true;
	}

	get lightningDualListbox(){
		return this.template.querySelector('lightning-dual-listbox');
	}

	get inputReadonly(){
		return !this.searchable;
	}

	get selectedItem(){
		const selectedValue = this.value || '';
		return this.options.find(option => option.value === selectedValue);
	}

	get selectedItemLabel(){
		if(this.filteredTerm || (this.searchable && this.isBeingFocused))
			return this.filteredTerm || '';
		if(this.multiple){
			if(this.value?.length > 0)
				return this.readOnly ? this.value.join(', ') : format(l.XSelectedOptions, [this.value.length]);
			return null;
		}
		return this.selectedItem?.label || '';
	}

	get formElementClass(){
		const formElementMode = this.readOnly ? 'slds-form-element_readonly' : 'slds-is-editing';
		return 'slds-form-element'
			+ (this.labelHidden ? '' : ' slds-form-element_stacked ' + formElementMode)
			+ (this.edit ? ' slds-form-element_edit' : '')
			+ (this.inputReadonly ? ' is-readonly' : '')
			+ (this.selectedItemLabel ? ' has-value' : '')
			+ (this.hasError ? ' slds-has-error' : '')
			+ (this.disabled ? ' is-disabled' : '');
	}

	get comboboxClass(){
		return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click' + (this.isOpened ? ' slds-is-open' : '');
	}

	get selectedItems(){
		if(this.value)
			return this.multiple ? this.value : [this.value];
		return [];
	}

	get filteredOptions(){
		let options = [];
		if(this.selectAllOption && this.multiple){
			options.push({ value: 'selectAll', label: l.SelectAll });
			options.push({ value: 'deselectAll', label: l.DeselectAll });
		}
		options = options.concat(this.options);
		if(this.filteredTerm){
			const searchTerm = this.filteredTerm.toLowerCase();
			return options.filter(option => option.label.toLowerCase().includes(searchTerm));
		}
		return options;
	}

	get isPicklist(){
		return this.type === 'picklist';
	}

	get isButton(){
		return this.type === 'button';
	}

	get isRadio(){
		return this.type === 'radio';
	}

	get isCheckbox(){
		return this.type === 'checkbox';
	}

	get isDual(){
		return this.type === 'dual';
	}

	get hasError(){
		const isValid = this.checkValidity();
		return !isValid && this.displayInvalidMsg;
	}

	get editTitle(){
		return `${l.Modify}: ${this.label}`;
	}

	get labelHidden(){
		return isEmpty(this.label) || this.variant === 'label-hidden';
	}

	get displayLabel(){
		return this.label && !this.labelHidden;
	}

	get inputRequired(){
		return this.required && !this.readOnly && !this.disabled;
	}

	get displayEdit(){
		return this.edit && !this.disabled;
	}

	get displaySelectedValues(){
		return this.multiple && !this.readOnly && this.displaySelection && this.value?.length > 0;
	}

	get selectedOptions(){
		return this.options.filter(option => this.value.includes(option.value));
	}

	get newRecordOption(){
		return { value: 'newRecord', label: this.newRecordOptionLabel };
	}

	setFilteredTerm(e){
		this.filteredTerm = e.target.value;
	}

	setFocusOn(e){
		this.isBeingFocused = true;
	}

	setFocusOut(e){
		this.isBeingFocused = false;
	}

	connectedCallback(){
		this.setupClickListener();
		if(this.isCheckbox || this.isDual)
			this._multiple = true;
		if(this.form && this.fieldName)
			this._value = this.form[this.fieldName];
	}

	setupClickListener(){
		this._watchClickOutsideComponent = this.watchClickOutsideComponent.bind(this);
		window.addEventListener('click', this._watchClickOutsideComponent);
	}

	watchClickOutsideComponent(){
		if(this.isOpened === true) this.closeListbox();
	}

	disconnectedCallback(){
		window.removeEventListener('click', this._watchClickOutsideComponent);
	}

	openListbox(){
		if(this.disabled)
			return;
		this.isOpened = true;
	}

	closeListbox(){
		this.isOpened = false;
		this.reportValidity();
	}

	ignore(e){
		e.stopPropagation();
		return false;
	}

	removeSelectedOption(e){
		const value = e.target.dataset.value;
		const valueIndexToDelete = this.value.indexOf(value);
		this.value.splice(valueIndexToDelete, 1);
		this.dispatchValueChange();
	}

	setValue(e){
		const item = e.detail.value;
		if(this.isCheckbox || this.isDual){
			this._value = e.detail.value;
		}else if(this.multiple){
			if(item === 'selectAll'){
				let value = [];
				this.options.forEach(option => value.push(option.value));
				this._value = value;
			}else if(item === 'deselectAll'){
				this._value = [];
			}else if(this.value?.length > 0){
				if(this.value.includes(item)){
					const valueIndexToDelete = this.value.indexOf(item);
					this.value.splice(valueIndexToDelete, 1);
				}else{
					this.value.push(item);
				}
			}else{
				this._value = [item];
			}
		}else{
			this._value = item;
		}
		this.filteredTerm = null;
		this.dispatchValueChange();
		if(!this.isCheckbox && !this.isDual && (!this.multiple || item === 'selectAll'))
			this.closeListbox();
	}

	dispatchValueChange(){
		this.dispatchEvent(new CustomEvent('valuechange', {
			detail: {
				value: this.value === '' ? null : this.value,
				fieldName: this.fieldName,
				selectedItem: this.selectedItem
			}
		}));
	}

	dispatchEdit(){
		this.dispatchEvent(new CustomEvent('edit'));
	}

	dispatchNewRecord(){
		this.dispatchEvent(new CustomEvent('newrecord'));
		this.closeListbox();
	}
}