import { LightningElement, api } from 'lwc';

export default class Section extends LightningElement{
	@api label;
	@api nonCollapsible = false;
	@api addTitlePadding = false;
	@api noBottomMargin = false;
	_closed = false;
	slotActionsClass;

	get closed(){
		return this._closed;
	}
	@api
	set closed(value){
		this._closed = value;
	}

	get selectionClass(){
		return 'slds-section'
			+ (this.noBottomMargin ? '' : ' slds-p-bottom_medium')
			+ (this.closed ? '' : ' slds-is-open');
	}

	get sectionTitleClass(){
		return 'slds-section__title' + (this.addTitlePadding ? ' slds-p-horizontal_small' : '');
	}

	@api
	open(){
		this._closed = false;
	}

	handleActionsSlotChange(e){
		const slot = e.target;
		this.slotActionsClass = slot.assignedElements()?.length > 0 ? 'slds-m-left_small' : null;
	}

	toggleClosed(){
		if(this.nonCollapsible)
			return;
		this._closed = !this.closed;
	}
}