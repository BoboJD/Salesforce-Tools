import { LightningElement, api } from 'lwc';
import label from './labels';

export default class PicklistOption extends LightningElement{
	@api option;
	@api selectedItems;
	@api button = false;
	@api disabledValues = [];
	@api newRecordOption = false;

	get displayIcon(){
		return this.isSelected || this.newRecordOption;
	}

	get isSelected(){
		return !this.newRecordOption && this.selectedItems.includes(this.option.value);
	}

	get iconName(){
		return this.newRecordOption ? 'utility:add' : 'utility:check';
	}

	get iconAlernativeText(){
		return this.newRecordOption ? label.NewRecord : label.Selected;
	}

	get className(){
		return 'slds-media slds-listbox__option slds-listbox__option_plain slds-media_small'
			+ (this.isSelected ? ' slds-is-selected' : '')
			+ (this.option.description ? ' slds-listbox__option_has-meta' : '');
	}

	get disabled(){
		return this.disabledValues.includes(this.option.value);
	}

	dispatchSelection(){
		if(this.disabled)
			return;
		this.dispatchEvent(new CustomEvent('select', {
			detail: {
				value: this.option.value
			}
		}));
	}
}