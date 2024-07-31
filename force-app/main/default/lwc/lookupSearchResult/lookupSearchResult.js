import { api, LightningElement } from 'lwc';
import { boldString } from 'c/utils';

export default class LookupSearchResult extends LightningElement{
	@api iconName;
	@api searchedTerm;
	@api index;
	@api searchResult;

	renderedCallback(){
		this.template.querySelector('.search-result-label').innerHTML = boldString(this.searchResult.label, this.searchedTerm);
	}

	dispatchSelectItem(){
		this.dispatchEvent(new CustomEvent('selectitem', {
			detail: {
				index: this.index
			}
		}));
	}
}