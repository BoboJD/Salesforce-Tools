import { api, LightningElement } from 'lwc';

export default class FilterSection extends LightningElement{
	@api section;

	get isCheckbox(){
		return this.section.type === 1;
	}

	dispatchValueChange(e){
		this.dispatchEvent(new CustomEvent('valuechange', {
			detail: {
				filterOption: this.section.filterOption,
				value: e.detail.value
			}
		}));
	}
}